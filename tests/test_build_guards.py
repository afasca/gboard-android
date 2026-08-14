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


def manifest_integer_attribute(data, resource_id):
    matches = split_patcher.find_attributes(data, {resource_id})[resource_id]
    assert len(matches) == 1
    return split_patcher.u32(data, matches[0] + 16)


def manifest_min_sdk(data):
    return manifest_integer_attribute(data, split_patcher.MIN_SDK_VERSION_ID)


def manifest_version_code(data):
    return manifest_integer_attribute(data, split_patcher.VERSION_CODE_ID)


def manifest_utf16_strings(data):
    pools = [chunk for chunk in split_patcher.chunks(data) if chunk[1] == split_patcher.RES_STRING_POOL_TYPE]
    assert len(pools) == 1
    pool, _, header_size, _ = pools[0]
    count = split_patcher.u32(data, pool + 8)
    strings_start = split_patcher.u32(data, pool + 20)
    values = []
    for index in range(count):
        relative = split_patcher.u32(data, pool + header_size + index * 4)
        position = pool + strings_start + relative
        length, length_size = split_patcher.decode_length16(data, position)
        start = position + length_size
        values.append(bytes(data[start : start + length * 2]).decode("utf-16le"))
    return values


def assert_idempotent_manifest_patch(apk, original_min_sdk, has_required_split):
    original = archive_manifest_bytes(apk)
    assert manifest_min_sdk(original) == original_min_sdk
    assert manifest_version_code(original) == split_patcher.UPSTREAM_VERSION_CODE
    assert split_patcher.UPSTREAM_VERSION_NAME in manifest_utf16_strings(original)
    assert bool(split_patcher.required_split_attribute(original)) is has_required_split
    with tempfile.TemporaryDirectory() as directory:
        manifest = Path(directory) / "AndroidManifest.xml"
        manifest.write_bytes(original)
        subprocess.run([str(SPLIT_PATCHER), str(manifest)], check=True)
        first = manifest.read_bytes()
        subprocess.run([str(SPLIT_PATCHER), str(manifest)], check=True)
        assert manifest.read_bytes() == first
        assert manifest_min_sdk(first) == 32
        assert manifest_version_code(first) == split_patcher.MYBOARD_VERSION_CODE
        strings = manifest_utf16_strings(first)
        assert strings.count(split_patcher.MYBOARD_VERSION_NAME) == 1
        assert split_patcher.UPSTREAM_VERSION_NAME not in strings
        assert not split_patcher.required_split_attribute(first)
        assert first != original


def test_fused_manifest_restores_support_floor_idempotently():
    assert_idempotent_manifest_patch(APK, original_min_sdk=26, has_required_split=False)


def test_play_base_manifest_removes_split_marker_idempotently():
    assert_idempotent_manifest_patch(PLAY_BASE_APK, original_min_sdk=32, has_required_split=True)


def test_unexpected_version_name_is_rejected():
    original = archive_manifest_bytes(APK)
    tampered = split_patcher.replace_utf16_pool_string(
        bytearray(original), split_patcher.UPSTREAM_VERSION_NAME, "17.8.99-unexpected-arm64-v8a"
    )
    with tempfile.TemporaryDirectory() as directory:
        manifest = Path(directory) / "AndroidManifest.xml"
        manifest.write_bytes(tampered)
        result = subprocess.run([str(SPLIT_PATCHER), str(manifest)], text=True, capture_output=True)
        assert result.returncode != 0
        assert "unexpected versionName" in result.stderr


def archive_manifest_bytes(apk):
    with zipfile.ZipFile(apk) as archive:
        return archive.read("AndroidManifest.xml")


if __name__ == "__main__":
    test_pinned_input()
    test_fused_manifest_restores_support_floor_idempotently()
    test_play_base_manifest_removes_split_marker_idempotently()
    test_unexpected_version_name_is_rejected()
    print("build guard tests passed")
