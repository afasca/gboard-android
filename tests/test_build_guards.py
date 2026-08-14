#!/usr/bin/env python3
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path
import subprocess
import tempfile
import zipfile

ROOT = Path(__file__).resolve().parents[1]
APK = ROOT / "fused-gboard-安卓.apk"
PLAY_BASE_APK = ROOT / "gboard-安卓.apk"
EXPECTED_SHA = "f06d8e42131a3feb7a05e1e42244af43059a67899bf1fa958290f18d8106dc5a"
EXPECTED_CERT = "f0fd6c5b410f25cb25c3b53346c8972fae30f8ee7411df910480ad6b2d60db83"
SPLIT_PATCHER = ROOT / "scripts/remove-required-split.py"
spec = spec_from_file_location("split_patcher", SPLIT_PATCHER)
split_patcher = module_from_spec(spec)
spec.loader.exec_module(split_patcher)


def test_pinned_input():
    actual_sha = subprocess.check_output(["sha256sum", APK], text=True).split()[0]
    assert actual_sha == EXPECTED_SHA
    output = subprocess.check_output(["apksigner", "verify", "--print-certs", APK], text=True)
    assert f"Signer #1 certificate SHA-256 digest: {EXPECTED_CERT}" in output


def manifest_min_sdk(data):
    resource_ids = []
    values = []
    for offset, chunk_type, header_size, chunk_size in split_patcher.chunks(data):
        if chunk_type == split_patcher.RES_XML_RESOURCE_MAP_TYPE:
            resource_ids = [
                split_patcher.u32(data, position)
                for position in range(offset + header_size, offset + chunk_size, 4)
            ]
        elif chunk_type == split_patcher.RES_XML_START_ELEMENT_TYPE and resource_ids:
            attribute_start = offset + 16 + split_patcher.u16(data, offset + 24)
            attribute_size = split_patcher.u16(data, offset + 26)
            attribute_count = split_patcher.u16(data, offset + 28)
            for index in range(attribute_count):
                attribute = attribute_start + index * attribute_size
                name_index = split_patcher.u32(data, attribute + 4)
                if name_index < len(resource_ids) and resource_ids[name_index] == split_patcher.MIN_SDK_VERSION_ID:
                    values.append(split_patcher.u32(data, attribute + 16))
    assert len(values) == 1
    return values[0]


def assert_idempotent_manifest_patch(apk, original_min_sdk, has_required_split):
    original = archive_manifest_bytes(apk)
    assert manifest_min_sdk(original) == original_min_sdk
    assert bool(split_patcher.required_split_attribute(original)) is has_required_split
    with tempfile.TemporaryDirectory() as directory:
        manifest = Path(directory) / "AndroidManifest.xml"
        manifest.write_bytes(original)
        subprocess.run([str(SPLIT_PATCHER), str(manifest)], check=True)
        first = manifest.read_bytes()
        subprocess.run([str(SPLIT_PATCHER), str(manifest)], check=True)
        assert manifest.read_bytes() == first
        assert manifest_min_sdk(first) == 32
        assert not split_patcher.required_split_attribute(first)
        if original_min_sdk != 32 or has_required_split:
            assert first != original


def test_fused_manifest_restores_support_floor_idempotently():
    assert_idempotent_manifest_patch(APK, original_min_sdk=26, has_required_split=False)


def test_play_base_manifest_removes_split_marker_idempotently():
    assert_idempotent_manifest_patch(PLAY_BASE_APK, original_min_sdk=32, has_required_split=True)


def archive_manifest_bytes(apk):
    with zipfile.ZipFile(apk) as archive:
        return archive.read("AndroidManifest.xml")


if __name__ == "__main__":
    test_pinned_input()
    test_fused_manifest_restores_support_floor_idempotently()
    test_play_base_manifest_removes_split_marker_idempotently()
    print("build guard tests passed")
