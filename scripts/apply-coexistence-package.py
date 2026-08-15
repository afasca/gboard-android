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
SMALI_REPLACEMENTS = {
    "smali/aizs.smali": 2,
    "smali/avqz.smali": 3,
    "smali_classes2/sdw.smali": 3,
    "smali_classes2/wew.smali": 1,
    "smali_classes2/wie.smali": 1,
    "smali_classes2/wim.smali": 1,
    "smali_classes2/wlc.smali": 1,
    "smali_classes2/wlk.smali": 1,
    "smali_classes2/xeh.smali": 1,
    "smali_classes2/xei.smali": 1,
    "smali_classes3/anmx.smali": 1,
    "smali_classes3/aofi.smali": 1,
    "smali_classes3/aplp.smali": 1,
}
# AllFlags.STATICMENDELPACKAGENAME and afzn are Google backend namespaces,
# not Android installation identity, so they intentionally stay official.
EXPECTED_MANIFEST_UTF16_OLD_AFTER = 2
LAUNCHER_SMALI = "smali_classes3/com/google/android/libraries/inputmethod/launcher/LauncherActivity.smali"

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


def global_string_pool(data: bytes):
    offset = struct.unpack_from("<H", data, 2)[0]
    while offset < len(data):
        chunk_type, header_size, chunk_size = struct.unpack_from("<HHI", data, offset)
        if chunk_type == 0x0001:
            return offset, header_size, chunk_size
        offset += chunk_size
    raise SystemExit("resource string pool was not found")


def decode_utf8_pool_string(data: bytes, pool_offset: int, strings_start: int, relative: int):
    position = pool_offset + strings_start + relative
    first = data[position]
    utf16_size = 2 if first & 0x80 else 1
    utf16_length = ((first & 0x7F) << 8 | data[position + 1]) if utf16_size == 2 else first
    position += utf16_size
    first = data[position]
    utf8_size = 2 if first & 0x80 else 1
    utf8_length = ((first & 0x7F) << 8 | data[position + 1]) if utf8_size == 2 else first
    position += utf8_size
    return utf16_length, utf8_length, position


def find_unique_utf8_pool_string(data: bytes, expected: str) -> int:
    offset, header_size, _ = global_string_pool(data)
    string_count, _, flags, strings_start, _ = struct.unpack_from("<IIIII", data, offset + 8)
    if not flags & 0x100:
        raise SystemExit("resource global string pool is not UTF-8")
    matches = []
    offsets_start = offset + header_size
    expected_encoded = expected.encode()
    for index in range(string_count):
        relative = struct.unpack_from("<I", data, offsets_start + index * 4)[0]
        _, utf8_length, position = decode_utf8_pool_string(data, offset, strings_start, relative)
        if utf8_length == len(expected_encoded) and data[position : position + utf8_length] == expected_encoded:
            matches.append(index)
    if len(matches) != 1:
        raise SystemExit(f"expected exactly one global string-pool entry {expected!r}, found {len(matches)}")
    return matches[0]


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
    old_utf16 = OLD_PACKAGE.encode("utf-16le")
    new_utf16 = NEW_PACKAGE.encode("utf-16le")
    if data.count(old_utf16) != EXPECTED_MANIFEST_UTF16:
        raise SystemExit(f"binary manifest package namespace: expected {EXPECTED_MANIFEST_UTF16} occurrences, found {data.count(old_utf16)}")
    # Preserve the two Phenotype registration metadata keys as official Google
    # backend namespaces. All other manifest uses are installation-local.
    backend_keys = (
        "com.google.android.gms.phenotype.registration.binarypb:" + OLD_PACKAGE,
        "com.google.android.gms.phenotype.registration.xml:" + OLD_PACKAGE,
    )
    preserved_spans = []
    for key in backend_keys:
        encoded = key.encode("utf-16le")
        if data.count(encoded) != 1:
            raise SystemExit(f"manifest backend namespace {key}: expected exactly one occurrence")
        start = data.index(encoded)
        package_start = start + len(encoded) - len(old_utf16)
        preserved_spans.append((package_start, old_utf16))
    data = bytearray(data.replace(old_utf16, new_utf16))
    for package_start, encoded in preserved_spans:
        data[package_start : package_start + len(encoded)] = encoded
    data = bytes(data)
    if data.count(old_utf16) != EXPECTED_MANIFEST_UTF16_OLD_AFTER:
        raise SystemExit("manifest official backend namespaces were not preserved")
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
    # ime_name points to the only exact "Gboard" entry in the global pool.
    # Resolve dynamically because fused standalone and Play base tables differ.
    data = replace_utf8_string_pool_entry(data, find_unique_utf8_pool_string(data, "Gboard"), "Gboard", "MyBoard")
    resources.write_bytes(data)



def patch_smali(root: Path) -> None:
    for relative, expected in SMALI_REPLACEMENTS.items():
        path = root / relative
        text = path.read_text(encoding="utf-8")
        count = text.count(OLD_PACKAGE)
        if count != expected:
            raise SystemExit(f"{relative}: expected {expected} package occurrences, found {count}")
        path.write_text(text.replace(OLD_PACKAGE, NEW_PACKAGE), encoding="utf-8")

    backend_files = (
        "smali/com/google/android/libraries/inputmethod/staticflag/AllFlags.smali",
        "smali_classes3/afzn.smali",
    )
    for relative in backend_files:
        text = (root / relative).read_text(encoding="utf-8")
        if text.count(OLD_PACKAGE) != 1:
            raise SystemExit(f"{relative}: official backend namespace is missing or ambiguous")

    launcher = root / LAUNCHER_SMALI
    text = launcher.read_text(encoding="utf-8")
    method_start = text.index(".method public final a()V")
    method_end = text.index(".end method", method_start) + len(".end method")
    fallback = """.method public final a()V
    .locals 1
    const/4 v0, 0x0
    invoke-virtual {p0, v0}, Lcom/google/android/libraries/inputmethod/launcher/LauncherActivity;->b(Z)V
    return-void
.end method"""
    text = text[:method_start] + fallback + text[method_end:]
    launcher.write_text(text, encoding="utf-8")


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
