#!/usr/bin/env python3
"""Give the patched APK an independent package identity for side-by-side installation."""

from pathlib import Path
import struct
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


def replace_utf8_string_pool_entry(data: bytes, index: int, expected: str, replacement: str) -> bytes:
    offset = struct.unpack_from("<H", data, 2)[0]
    while offset < len(data):
        chunk_type, header_size, chunk_size = struct.unpack_from("<HHI", data, offset)
        if chunk_type == 0x0001:
            string_count, style_count, flags, strings_start, styles_start = struct.unpack_from("<IIIII", data, offset + 8)
            if not flags & 0x100 or index >= string_count or style_count == 0:
                raise SystemExit("resource string pool or IME label index is unexpected")
            offsets_start = offset + header_size
            relative = struct.unpack_from("<I", data, offsets_start + index * 4)[0]
            value_offset = offset + strings_start + relative
            encoded = expected.encode()
            old_value = bytes((len(expected), len(encoded))) + encoded + b"\0"
            if data[value_offset : value_offset + len(old_value)] != old_value:
                raise SystemExit("default IME label resource did not match Gboard")
            new_encoded = replacement.encode()
            new_value = bytes((len(replacement), len(new_encoded))) + new_encoded + b"\0"
            if len(new_value) > len(old_value):
                new_value += b"\0" * ((len(new_value) - len(old_value)) % 4 and (4 - (len(new_value) - len(old_value)) % 4))
            delta = len(new_value) - len(old_value)
            patched = bytearray(data)
            patched[value_offset : value_offset + len(old_value)] = new_value
            for string_index in range(index + 1, string_count):
                position = offsets_start + string_index * 4
                struct.pack_into("<I", patched, position, struct.unpack_from("<I", patched, position)[0] + delta)
            struct.pack_into("<I", patched, offset + 24, styles_start + delta)
            struct.pack_into("<I", patched, offset + 4, chunk_size + delta)
            struct.pack_into("<I", patched, 4, len(patched))
            return bytes(patched)
        offset += chunk_size
    raise SystemExit("resource string pool was not found")


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
    # Resource 0x7f140525 (ime_name) points to global string-pool index 0x2c90.
    # Patch exactly that entry so other UI copy containing "Gboard" is unchanged.
    data = replace_utf8_string_pool_entry(data, 0x2C90, "Gboard", "MyBoard")
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
