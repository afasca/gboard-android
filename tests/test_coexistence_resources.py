#!/usr/bin/env python3
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path
import struct
import tempfile

ROOT = Path(__file__).resolve().parents[1]
spec = spec_from_file_location("coexist", ROOT / "scripts/apply-coexistence-package.py")
coexist = module_from_spec(spec)
spec.loader.exec_module(coexist)


def utf8_pool(strings):
    header_size = 28
    offsets = []
    payload = bytearray()
    for value in strings:
        encoded = value.encode()
        offsets.append(len(payload))
        payload += bytes((len(value), len(encoded))) + encoded + b"\0"
    payload += b"\0" * ((-len(payload)) % 4)
    styles = b"\xff" * 8
    strings_start = header_size + len(offsets) * 4
    styles_start = strings_start + len(payload)
    size = styles_start + len(styles)
    chunk = bytearray(size)
    struct.pack_into("<HHI", chunk, 0, 0x0001, header_size, size)
    struct.pack_into("<IIIII", chunk, 8, len(strings), 1, 0x100, strings_start, styles_start)
    for index, offset in enumerate(offsets):
        struct.pack_into("<I", chunk, header_size + index * 4, offset)
    chunk[strings_start:styles_start] = payload
    chunk[styles_start:] = styles
    return bytes(chunk)


def wrapped_table(pool):
    table = bytearray(12 + len(pool))
    struct.pack_into("<HHI", table, 0, 0x0002, 12, len(table))
    struct.pack_into("<I", table, 8, 1)
    table[12:] = pool
    return bytes(table)


def read_pool_string(data, index):
    pool = 12
    header_size = struct.unpack_from("<H", data, pool + 2)[0]
    strings_start = struct.unpack_from("<I", data, pool + 20)[0]
    relative = struct.unpack_from("<I", data, pool + header_size + index * 4)[0]
    position = pool + strings_start + relative
    utf16_length, utf8_length = data[position], data[position + 1]
    value = data[position + 2 : position + 2 + utf8_length].decode()
    return utf16_length, value


def test_label_growth_updates_offsets_and_sizes():
    original = wrapped_table(utf8_pool(["before", "Gboard", "after"]))
    patched = coexist.replace_utf8_string_pool_entry(original, 1, "Gboard", "MyBoard")
    assert len(patched) == len(original) + 4
    assert struct.unpack_from("<I", patched, 4)[0] == len(patched)
    assert struct.unpack_from("<I", patched, 12 + 4)[0] == len(patched) - 12
    assert read_pool_string(patched, 0) == (6, "before")
    assert read_pool_string(patched, 1) == (7, "MyBoard")
    assert read_pool_string(patched, 2) == (5, "after")


def test_label_mismatch_rejected():
    original = wrapped_table(utf8_pool(["before", "Other", "after"]))
    try:
        coexist.replace_utf8_string_pool_entry(original, 1, "Gboard", "MyBoard")
    except SystemExit as error:
        assert "did not match Gboard" in str(error)
    else:
        raise AssertionError("mismatched label was accepted")


def test_replace_exact_rejects_wrong_count():
    try:
        coexist.replace_exact(b"old-old", b"old", b"new", 1, "fixture")
    except SystemExit as error:
        assert "expected 1 occurrences, found 2" in str(error)
    else:
        raise AssertionError("ambiguous replacement was accepted")


if __name__ == "__main__":
    test_label_growth_updates_offsets_and_sizes()
    test_label_mismatch_rejected()
    test_replace_exact_rejects_wrong_count()
    print("coexistence resource tests passed")
