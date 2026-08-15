#!/usr/bin/env python3
"""Patch standalone-build and MyBoard app-version metadata in binary AndroidManifest.xml."""

from pathlib import Path
import struct
import sys

RES_STRING_POOL_TYPE = 0x0001
RES_XML_TYPE = 0x0003
RES_XML_RESOURCE_MAP_TYPE = 0x0180
RES_XML_START_ELEMENT_TYPE = 0x0102
REQUIRED_SPLIT_TYPES_ID = 0x0101064E
MIN_SDK_VERSION_ID = 0x0101020C
VERSION_CODE_ID = 0x0101021B
VERSION_NAME_ID = 0x0101021C
MIN_SDK_VERSION = 32
UPSTREAM_VERSION_CODE = 175894494
MYBOARD_VERSION_CODE = 175894496
UPSTREAM_VERSION_NAME = "17.8.3.939743344-beta-arm64-v8a"
MYBOARD_VERSION_NAME = "17.8.5.939743346-beta-arm64-v8a"


def u16(data: bytes | bytearray, offset: int) -> int:
    return struct.unpack_from("<H", data, offset)[0]


def u32(data: bytes | bytearray, offset: int) -> int:
    return struct.unpack_from("<I", data, offset)[0]


def chunks(data: bytes | bytearray):
    offset = u16(data, 2)
    while offset < len(data):
        if offset + 8 > len(data):
            raise SystemExit("binary manifest contains a truncated chunk header")
        chunk_type = u16(data, offset)
        header_size = u16(data, offset + 2)
        chunk_size = u32(data, offset + 4)
        if header_size < 8 or chunk_size < header_size or offset + chunk_size > len(data):
            raise SystemExit(f"binary manifest contains an invalid chunk at offset {offset}")
        yield offset, chunk_type, header_size, chunk_size
        offset += chunk_size
    if offset != len(data):
        raise SystemExit("binary manifest chunk sizes do not match the file size")


def required_split_attribute(data: bytes | bytearray):
    resource_ids: list[int] = []
    root_start = None
    for offset, chunk_type, header_size, chunk_size in chunks(data):
        if chunk_type == RES_XML_RESOURCE_MAP_TYPE:
            if (chunk_size - header_size) % 4:
                raise SystemExit("binary manifest has an invalid resource map")
            resource_ids = [
                u32(data, position)
                for position in range(offset + header_size, offset + chunk_size, 4)
            ]
        elif chunk_type == RES_XML_START_ELEMENT_TYPE:
            root_start = offset
            break

    if root_start is None or not resource_ids:
        raise SystemExit("binary manifest root or resource map was not found")

    attribute_start = root_start + 16 + u16(data, root_start + 24)
    attribute_size = u16(data, root_start + 26)
    attribute_count = u16(data, root_start + 28)
    if attribute_size != 20:
        raise SystemExit(f"unsupported binary manifest attribute size: {attribute_size}")

    matches = []
    for index in range(attribute_count):
        offset = attribute_start + index * attribute_size
        name_index = u32(data, offset + 4)
        if name_index < len(resource_ids) and resource_ids[name_index] == REQUIRED_SPLIT_TYPES_ID:
            matches.append((root_start, offset, attribute_size, index))
    return matches


def find_attributes(data: bytes | bytearray, wanted_ids: set[int]):
    resource_ids: list[int] = []
    matches = {resource_id: [] for resource_id in wanted_ids}
    for offset, chunk_type, header_size, chunk_size in chunks(data):
        if chunk_type == RES_XML_RESOURCE_MAP_TYPE:
            if (chunk_size - header_size) % 4:
                raise SystemExit("binary manifest has an invalid resource map")
            resource_ids = [
                u32(data, position)
                for position in range(offset + header_size, offset + chunk_size, 4)
            ]
        elif chunk_type == RES_XML_START_ELEMENT_TYPE and resource_ids:
            attribute_start = offset + 16 + u16(data, offset + 24)
            attribute_size = u16(data, offset + 26)
            attribute_count = u16(data, offset + 28)
            if attribute_size != 20:
                raise SystemExit(f"unsupported binary manifest attribute size: {attribute_size}")
            for index in range(attribute_count):
                attribute = attribute_start + index * attribute_size
                name_index = u32(data, attribute + 4)
                if name_index < len(resource_ids) and resource_ids[name_index] in matches:
                    matches[resource_ids[name_index]].append(attribute)
    return matches


def set_integer_attribute(data: bytearray, resource_id: int, expected: int | tuple[int, ...], value: int, name: str) -> None:
    matches = find_attributes(data, {resource_id})[resource_id]
    if len(matches) != 1:
        raise SystemExit(f"binary manifest: expected exactly one {name}, found {len(matches)}")
    attribute = matches[0]
    if data[attribute + 15] not in (0x10, 0x11):
        raise SystemExit(f"binary manifest {name} is not an integer value")
    actual = u32(data, attribute + 16)
    expected_values = (expected,) if isinstance(expected, int) else expected
    if actual not in expected_values:
        raise SystemExit(f"binary manifest: expected {name} {expected_values}, found {actual}")
    struct.pack_into("<I", data, attribute + 16, value)


def decode_length16(data: bytes | bytearray, offset: int) -> tuple[int, int]:
    first = u16(data, offset)
    if first & 0x8000:
        return ((first & 0x7FFF) << 16) | u16(data, offset + 2), 4
    return first, 2


def encode_length16(length: int) -> bytes:
    if length < 0x8000:
        return struct.pack("<H", length)
    return struct.pack("<HH", 0x8000 | (length >> 16), length & 0xFFFF)


def utf16_pool(data: bytes | bytearray):
    pools = [chunk for chunk in chunks(data) if chunk[1] == RES_STRING_POOL_TYPE]
    if len(pools) != 1:
        raise SystemExit(f"binary manifest: expected one string pool, found {len(pools)}")
    pool, _, header_size, pool_size = pools[0]
    if u32(data, pool + 16) & 0x100:
        raise SystemExit("binary manifest uses an unexpected UTF-8 string pool")
    return pool, header_size, pool_size


def utf16_pool_string(data: bytes | bytearray, index: int) -> str:
    pool, header_size, _ = utf16_pool(data)
    string_count = u32(data, pool + 8)
    if index >= string_count:
        raise SystemExit(f"binary manifest string index is out of bounds: {index}")
    strings_start = u32(data, pool + 20)
    relative = u32(data, pool + header_size + index * 4)
    position = pool + strings_start + relative
    length, length_size = decode_length16(data, position)
    start = position + length_size
    return bytes(data[start : start + length * 2]).decode("utf-16le")


def replace_utf16_pool_string(data: bytearray, expected: str, replacement: str) -> bytearray:
    pool, header_size, pool_size = utf16_pool(data)
    string_count = u32(data, pool + 8)
    style_count = u32(data, pool + 12)
    strings_start = u32(data, pool + 20)
    styles_start = u32(data, pool + 24)

    matches = []
    offsets = []
    for index in range(string_count):
        relative = u32(data, pool + header_size + index * 4)
        offsets.append(relative)
        position = pool + strings_start + relative
        length, length_size = decode_length16(data, position)
        start = position + length_size
        end = start + length * 2
        value = bytes(data[start:end]).decode("utf-16le")
        if value == expected:
            matches.append((index, position, end + 2))
    if len(matches) != 1:
        raise SystemExit(f"binary manifest: expected one versionName {expected!r}, found {len(matches)}")

    matched_index, start, end = matches[0]
    encoded = encode_length16(len(replacement)) + replacement.encode("utf-16le") + b"\0\0"
    delta = len(encoded) - (end - start)
    aligned_delta = (delta + 3) & ~3
    encoded += b"\0" * (aligned_delta - delta)
    data[start:end] = encoded

    for index in range(matched_index + 1, string_count):
        struct.pack_into("<I", data, pool + header_size + index * 4, offsets[index] + aligned_delta)
    if style_count and styles_start:
        struct.pack_into("<I", data, pool + 24, styles_start + aligned_delta)
    struct.pack_into("<I", data, pool + 4, pool_size + aligned_delta)
    struct.pack_into("<I", data, 4, len(data))
    return data


def set_app_version(data: bytearray) -> bytearray:
    attributes = find_attributes(data, {VERSION_CODE_ID, VERSION_NAME_ID})
    version_name_matches = attributes[VERSION_NAME_ID]
    if len(version_name_matches) != 1:
        raise SystemExit(f"binary manifest: expected exactly one versionName, found {len(version_name_matches)}")
    version_name = version_name_matches[0]
    old_index = u32(data, version_name + 8)
    typed_index = u32(data, version_name + 16)
    if old_index != typed_index:
        raise SystemExit("binary manifest versionName raw and typed strings differ")
    if old_index == 0xFFFFFFFF:
        raise SystemExit("binary manifest versionName does not contain a string")
    actual_name = utf16_pool_string(data, old_index)
    if actual_name != UPSTREAM_VERSION_NAME:
        raise SystemExit(f"binary manifest: expected versionName {UPSTREAM_VERSION_NAME!r}, found {actual_name!r}")
    data = replace_utf16_pool_string(data, UPSTREAM_VERSION_NAME, MYBOARD_VERSION_NAME)
    set_integer_attribute(data, VERSION_CODE_ID, (UPSTREAM_VERSION_CODE, MYBOARD_VERSION_CODE), MYBOARD_VERSION_CODE, "versionCode")
    return data


def patch_manifest(path: Path) -> None:
    data = bytearray(path.read_bytes())
    if len(data) < 8 or u16(data, 0) != RES_XML_TYPE or u32(data, 4) != len(data):
        raise SystemExit(f"{path}: not a valid binary Android XML file")
    set_integer_attribute(data, MIN_SDK_VERSION_ID, (26, MIN_SDK_VERSION), MIN_SDK_VERSION, "minSdkVersion")

    # App-version metadata is idempotent: retain the patched natural version, otherwise require the pinned upstream value.
    version_name_attribute = find_attributes(data, {VERSION_NAME_ID})[VERSION_NAME_ID]
    if len(version_name_attribute) != 1:
        raise SystemExit(f"binary manifest: expected exactly one versionName, found {len(version_name_attribute)}")
    version_name_index = u32(data, version_name_attribute[0] + 16)
    version_name = utf16_pool_string(data, version_name_index)
    if version_name == UPSTREAM_VERSION_NAME:
        data = set_app_version(data)
    elif version_name == MYBOARD_VERSION_NAME:
        set_integer_attribute(data, VERSION_CODE_ID, MYBOARD_VERSION_CODE, MYBOARD_VERSION_CODE, "versionCode")
    else:
        raise SystemExit(f"binary manifest: unexpected versionName {version_name!r}")

    matches = required_split_attribute(data)
    if matches:
        if len(matches) != 1:
            raise SystemExit(f"{path}: expected at most one requiredSplitTypes attribute, found {len(matches)}")
        root_start, attribute_offset, attribute_size, removed_index = matches[0]
        struct.pack_into("<I", data, 4, len(data) - attribute_size)
        struct.pack_into("<I", data, root_start + 4, u32(data, root_start + 4) - attribute_size)
        struct.pack_into("<H", data, root_start + 28, u16(data, root_start + 28) - 1)

        # idIndex/classIndex/styleIndex are 1-based positions within the attribute array.
        removed_position = removed_index + 1
        for field_offset in (30, 32, 34):
            position = u16(data, root_start + field_offset)
            if position == removed_position:
                raise SystemExit("requiredSplitTypes unexpectedly occupies a special attribute index")
            if position > removed_position:
                struct.pack_into("<H", data, root_start + field_offset, position - 1)
        del data[attribute_offset : attribute_offset + attribute_size]
        if required_split_attribute(data):
            raise SystemExit("requiredSplitTypes remained after binary manifest patch")
    path.write_bytes(data)


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("usage: remove-required-split.py <binary AndroidManifest.xml>")
    patch_manifest(Path(sys.argv[1]))


if __name__ == "__main__":
    main()
