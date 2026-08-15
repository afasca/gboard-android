#!/usr/bin/env bash
set -euo pipefail

APK="${1:?usage: verify-built-apk.sh <apk>}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INPUT_APK="${INPUT_APK:-$ROOT/fused-gboard-安卓.apk}"
APKTOOL_JAR="${APKTOOL_JAR:-$ROOT/tools/apktool_2.12.0.jar}"
ZIPALIGN="${ZIPALIGN:-zipalign}"
EXPECTED_PACKAGE="com.vorflux.gboard.inputmethod.latin"
EXPECTED_LABEL="MyBoard"
EXPECTED_VERSION_CODE="175894496"
EXPECTED_VERSION_NAME="17.8.5.939743346-beta-arm64-v8a"
EXPECTED_MIN_SDK="32"
EXPECTED_TARGET_SDK="37"
EXPECTED_ABI="arm64-v8a"
EXPECTED_CERT_SHA256="72f35793e9f17aba292fe6dd1607eca6b783cf779ca52b1561f03e5bc411ebeb"

[[ -f "$APK" ]] || { echo "Missing APK $APK" >&2; exit 1; }
[[ -f "$INPUT_APK" ]] || { echo "Missing fused input APK $INPUT_APK" >&2; exit 1; }
[[ -f "$APKTOOL_JAR" ]] || { echo "Missing apktool $APKTOOL_JAR" >&2; exit 1; }
for tool in aapt apksigner unzip readelf; do
  command -v "$tool" >/dev/null || { echo "Missing required tool: $tool" >&2; exit 1; }
done

BADGING="$(aapt dump badging "$APK")"
grep -q "^package: name='$EXPECTED_PACKAGE' versionCode='$EXPECTED_VERSION_CODE' versionName='$EXPECTED_VERSION_NAME' " <<<"$BADGING"
grep -q "^sdkVersion:'$EXPECTED_MIN_SDK'$" <<<"$BADGING"
grep -q "^targetSdkVersion:'$EXPECTED_TARGET_SDK'$" <<<"$BADGING"
grep -q "^application-label:'$EXPECTED_LABEL'$" <<<"$BADGING"
grep -q "^native-code: '$EXPECTED_ABI'$" <<<"$BADGING"

MANIFEST="$(aapt dump xmltree "$APK" AndroidManifest.xml)"
grep -q 'android:minSdkVersion(0x0101020c)=(type 0x10)0x20' <<<"$MANIFEST"
if grep -qE 'requiredSplitTypes|splitTypes|isSplitRequired' <<<"$MANIFEST"; then
  echo "Unexpected split requirement in final manifest" >&2
  exit 1
fi

SIGNING="$(apksigner verify --verbose --print-certs "$APK")"
grep -q '^Verified using v3 scheme (APK Signature Scheme v3): true$' <<<"$SIGNING"
grep -q "certificate SHA-256 digest: $EXPECTED_CERT_SHA256$" <<<"$SIGNING"

ZIPALIGN_HELP="$($ZIPALIGN 2>&1 || true)"
if ! grep -q -- '-P <pagesize_kb>' <<<"$ZIPALIGN_HELP"; then
  echo "zipalign must be Android Build Tools 35+ (missing -P 16 support)" >&2
  exit 1
fi
"$ZIPALIGN" -c -P 16 4 "$APK"

mapfile -t ABIS < <(unzip -Z1 "$APK" | sed -n 's#^lib/\([^/]*\)/.*#\1#p' | sort -u)
[[ "${#ABIS[@]}" -eq 1 && "${ABIS[0]}" == "$EXPECTED_ABI" ]] || {
  printf 'Unexpected APK ABIs: %s\n' "${ABIS[*]}" >&2
  exit 1
}

python3 - "$APK" "$INPUT_APK" <<'PY'
import hashlib
import subprocess
import sys
import tempfile
import zipfile

apk, input_apk = sys.argv[1:]
with open(apk, "rb") as raw, zipfile.ZipFile(apk) as archive, zipfile.ZipFile(input_apk) as source:
    source_resources = {
        entry.filename for entry in source.infolist()
        if entry.filename == "resources.arsc" or entry.filename.startswith("res/")
    }
    output_resources = {
        entry.filename for entry in archive.infolist()
        if entry.filename == "resources.arsc" or entry.filename.startswith("res/")
    }
    assert output_resources == source_resources, "resource entry set differs from the pinned fused input"
    # resources.arsc is intentionally changed only for package identity and visible label.
    for name in sorted(source_resources - {"resources.arsc"}):
        assert hashlib.sha256(archive.read(name)).digest() == hashlib.sha256(source.read(name)).digest(), (
            f"resource content differs from fused input: {name}"
        )

    libraries = [
        entry for entry in archive.infolist()
        if entry.filename.startswith("lib/arm64-v8a/") and entry.filename.endswith(".so")
    ]
    assert len(libraries) == 15, f"expected 15 ARM64 libraries, found {len(libraries)}"
    with tempfile.TemporaryDirectory() as directory:
        for index, entry in enumerate(libraries):
            assert entry.compress_type == zipfile.ZIP_STORED, f"compressed native library: {entry.filename}"
            raw.seek(entry.header_offset)
            header = raw.read(30)
            name_size = int.from_bytes(header[26:28], "little")
            extra_size = int.from_bytes(header[28:30], "little")
            data_offset = entry.header_offset + 30 + name_size + extra_size
            assert data_offset % 16384 == 0, f"misaligned native library: {entry.filename}"

            library_path = f"{directory}/{index}.so"
            with open(library_path, "wb") as library:
                library.write(archive.read(entry))
            program_headers = subprocess.check_output(["readelf", "-lW", library_path], text=True)
            load_alignments = [
                int(line.split()[-1], 16)
                for line in program_headers.splitlines()
                if line.lstrip().startswith("LOAD ")
            ]
            assert load_alignments and all(alignment >= 0x4000 for alignment in load_alignments), (
                f"ELF PT_LOAD alignment below 0x4000: {entry.filename}"
            )
PY

python3 "$ROOT/scripts/verify-fixed-holder-contracts.py" \
  --apktool "$APKTOOL_JAR" "$APK"

echo "verified $APK"
