#!/usr/bin/env python3
"""Patch standalone-build requirements in a binary AndroidManifest.xml."""

from pathlib import Path
import struct
import sys

RES_XML_TYPE = 0x0003
RES_XML_RESOURCE_MAP_TYPE = 0x0180
RES_XML_START_ELEMENT_TYPE = 0x0102
REQUIRED_SPLIT_TYPES_ID = 0x0101064E
MIN_SDK_VERSION_ID = 0x0101020C
MIN_SDK_VERSION = 32


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


def set_min_sdk(data: bytearray) -> None:
    resource_ids: list[int] = []
    matches = []
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
                if name_index < len(resource_ids) and resource_ids[name_index] == MIN_SDK_VERSION_ID:
                    matches.append(attribute)
    if len(matches) != 1:
        raise SystemExit(f"binary manifest: expected exactly one minSdkVersion, found {len(matches)}")
    attribute = matches[0]
    if data[attribute + 15] not in (0x10, 0x11):
        raise SystemExit("binary manifest minSdkVersion is not an integer value")
    struct.pack_into("<I", data, attribute + 16, MIN_SDK_VERSION)


def remove_required_split(path: Path) -> None:
    data = bytearray(path.read_bytes())
    if len(data) < 8 or u16(data, 0) != RES_XML_TYPE or u32(data, 4) != len(data):
        raise SystemExit(f"{path}: not a valid binary Android XML file")
    set_min_sdk(data)

    matches = required_split_attribute(data)
    if not matches:
        path.write_bytes(data)
        return
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
    remove_required_split(Path(sys.argv[1]))


if __name__ == "__main__":
    main()
