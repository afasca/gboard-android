#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APKTOOL_JAR="${APKTOOL_JAR:-$ROOT/tools/apktool_2.12.0.jar}"
INPUT_APK="${1:-$ROOT/fused-gboard-安卓.apk}"
EXPECTED_INPUT_SHA256="f06d8e42131a3feb7a05e1e42244af43059a67899bf1fa958290f18d8106dc5a"
EXPECTED_INPUT_CERT_SHA256="f0fd6c5b410f25cb25c3b53346c8972fae30f8ee7411df910480ad6b2d60db83"
UNSIGNED="$ROOT/build/gboard-ai-unsigned-$$.apk"
ALIGNED="$ROOT/build/gboard-ai-aligned-$$.apk"
OUTPUT="${OUTPUT_APK:-$ROOT/build/MyBoard-AI-v6.apk}"
KEYSTORE="${KEYSTORE:-$ROOT/build/gboard-ai.keystore}"
EXPECTED_CERT_SHA256="72f35793e9f17aba292fe6dd1607eca6b783cf779ca52b1561f03e5bc411ebeb"
SIGNED_TMP="$ROOT/build/gboard-ai-signed-$$.apk"

[[ -f "$APKTOOL_JAR" ]] || { echo "Missing $APKTOOL_JAR" >&2; exit 1; }
[[ -f "$INPUT_APK" ]] || { echo "Missing fused input APK $INPUT_APK" >&2; exit 1; }
if [[ -z "${ALLOW_UNVERIFIED_INPUT:-}" ]]; then
  ACTUAL_INPUT_SHA256="$(sha256sum "$INPUT_APK" | awk '{print $1}')"
  [[ "$ACTUAL_INPUT_SHA256" == "$EXPECTED_INPUT_SHA256" ]] || { echo "Unexpected input APK SHA-256: $ACTUAL_INPUT_SHA256" >&2; exit 1; }
  ACTUAL_INPUT_CERT_SHA256="$(apksigner verify --print-certs "$INPUT_APK" | sed -n 's/^Signer #1 certificate SHA-256 digest: //p')"
  [[ "$ACTUAL_INPUT_CERT_SHA256" == "$EXPECTED_INPUT_CERT_SHA256" ]] || { echo "Unexpected input signer: $ACTUAL_INPUT_CERT_SHA256" >&2; exit 1; }
fi
mkdir -p "$ROOT/build"
# Use a per-process work directory so concurrent verification builds cannot corrupt each other.
WORK="$ROOT/build/decoded-raw-$$"
trap 'rm -rf "$WORK" "$UNSIGNED" "$ALIGNED" "$SIGNED_TMP"' EXIT
java -jar "$APKTOOL_JAR" d -r "$INPUT_APK" -o "$WORK"
python3 "$ROOT/scripts/apply-smali-patches.py" "$WORK"
python3 "$ROOT/scripts/apply-coexistence-package.py" "$WORK"
# Keep the original repository APK's Android 12L support floor and remove any
# Play split-install marker so this fused-resource build remains a single APK.
python3 "$ROOT/scripts/remove-required-split.py" "$WORK/AndroidManifest.xml"
mkdir -p "$WORK/smali_classes4"
cp -a "$ROOT/patch/smali/." "$WORK/smali_classes4/"
java -jar "$APKTOOL_JAR" b "$WORK" -o "$UNSIGNED"
# Gboard ships uncompressed ARM64 libraries with 16 KiB ELF alignment and
# extractNativeLibs=false. Preserve 16 KiB APK entry alignment for 16 KiB-page devices.
# Android Build Tools 35+ is required for -P 16.
ZIPALIGN="${ZIPALIGN:-zipalign}"
ZIPALIGN_HELP="$($ZIPALIGN 2>&1 || true)"
if ! grep -q -- '-P <pagesize_kb>' <<<"$ZIPALIGN_HELP"; then
  echo "zipalign must be Android Build Tools 35+ (missing -P 16 support)" >&2
  exit 1
fi
"$ZIPALIGN" -P 16 -f 4 "$UNSIGNED" "$ALIGNED"
"$ZIPALIGN" -c -P 16 4 "$ALIGNED"
if [[ ! -f "$KEYSTORE" ]]; then
  echo "Missing development keystore $KEYSTORE; set KEYSTORE=/path/to/the repository development keystore" >&2
  echo "The signer is pinned by Gboard's internal certificate allowlist and cannot be regenerated." >&2
  exit 1
fi
ACTUAL_CERT_SHA256="$(keytool -list -v -keystore "$KEYSTORE" -storepass android -alias gboard-ai | sed -n 's/^[[:space:]]*SHA256: //p' | tr -d ':[:space:]' | tr 'A-F' 'a-f')"
if [[ "$ACTUAL_CERT_SHA256" != "$EXPECTED_CERT_SHA256" ]]; then
  echo "The APK whitelist is bound to the repository development certificate $EXPECTED_CERT_SHA256; got $ACTUAL_CERT_SHA256" >&2
  exit 1
fi
apksigner sign --ks "$KEYSTORE" --ks-key-alias gboard-ai \
  --ks-pass pass:android --key-pass pass:android --out "$SIGNED_TMP" "$ALIGNED"
apksigner verify --verbose --print-certs "$SIGNED_TMP"
mkdir -p "$(dirname "$OUTPUT")"
ZIPALIGN="$ZIPALIGN" INPUT_APK="$INPUT_APK" "$ROOT/scripts/verify-built-apk.sh" "$SIGNED_TMP"
mkdir -p "$(dirname "$OUTPUT")"
mv -f "$SIGNED_TMP" "$OUTPUT"
rm -f "$SIGNED_TMP.idsig" "$OUTPUT.idsig"
echo "$OUTPUT"
