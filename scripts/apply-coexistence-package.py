#!/usr/bin/env python3
"""Give the patched APK an independent package identity for side-by-side installation."""

from pathlib import Path
import sys

OLD_PACKAGE = "com.google.android.inputmethod.latin"
NEW_PACKAGE = "com.vorflux.gboard.inputmethod.latin"
EXPECTED_MANIFEST_UTF16 = 15
# In resources.arsc only the UTF-16 resource package-table name is installation
# identity. UTF-8 occurrences are an external app allowlist and Play Store URLs.
EXPECTED_RESOURCES_UTF16 = 1
EXPECTED_SMALI = 20
NAMESPACE_PAYLOADS = (
    "res/ywe.binarypb",
    "res/Mox.xml",
    "assets/phenotype/com_google_android_inputmethod_latin_package_metadata.binarypb",
)

if len(OLD_PACKAGE) != len(NEW_PACKAGE):
    raise RuntimeError("coexistence package must remain the same encoded length")


def replace_exact(data: bytes, old: bytes, new: bytes, expected: int, label: str) -> bytes:
    count = data.count(old)
    if count != expected:
        raise SystemExit(f"{label}: expected {expected} occurrences, found {count}")
    patched = data.replace(old, new)
    if old in patched:
        raise SystemExit(f"{label}: old package remained after replacement")
    return patched


def patch_binary_files(root: Path) -> None:
    manifest = root / "AndroidManifest.xml"
    data = manifest.read_bytes()
    data = replace_exact(
        data,
        OLD_PACKAGE.encode("utf-16le"),
        NEW_PACKAGE.encode("utf-16le"),
        EXPECTED_MANIFEST_UTF16,
        "binary manifest package namespace",
    )
    manifest.write_bytes(data)

    resources = root / "resources.arsc"
    data = resources.read_bytes()
    data = replace_exact(
        data,
        OLD_PACKAGE.encode("utf-16le"),
        NEW_PACKAGE.encode("utf-16le"),
        EXPECTED_RESOURCES_UTF16,
        "resource table UTF-16 package namespace",
    )
    resources.write_bytes(data)

    for relative in NAMESPACE_PAYLOADS:
        path = root / relative
        data = replace_exact(
            path.read_bytes(),
            OLD_PACKAGE.encode(),
            NEW_PACKAGE.encode(),
            1,
            f"configuration namespace {relative}",
        )
        path.write_bytes(data)

    old_asset = root / "assets/phenotype/com_google_android_inputmethod_latin_package_metadata.binarypb"
    new_asset = root / "assets/phenotype/com_vorflux_gboard_inputmethod_latin_package_metadata.binarypb"
    if new_asset.exists():
        raise SystemExit(f"configuration metadata asset already exists: {new_asset}")
    old_asset.rename(new_asset)


def patch_smali(root: Path) -> None:
    files = []
    total = 0
    for directory in sorted(root.glob("smali*")):
        for path in sorted(directory.rglob("*.smali")):
            text = path.read_text(encoding="utf-8")
            count = text.count(OLD_PACKAGE)
            if count:
                files.append((path, text.replace(OLD_PACKAGE, NEW_PACKAGE)))
                total += count
    if total != EXPECTED_SMALI:
        raise SystemExit(f"smali package namespace: expected {EXPECTED_SMALI} occurrences, found {total}")
    for path, text in files:
        path.write_text(text, encoding="utf-8")


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit(f"usage: {Path(sys.argv[0]).name} <decoded APK directory>")
    root = Path(sys.argv[1])
    if not root.is_dir():
        raise SystemExit(f"decoded APK directory not found: {root}")
    patch_binary_files(root)
    patch_smali(root)


if __name__ == "__main__":
    main()
