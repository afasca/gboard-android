#!/usr/bin/env python3
from pathlib import Path
import shutil
import subprocess
import tempfile
import zipfile

ROOT = Path(__file__).resolve().parents[1]
APK = ROOT / "fused-gboard-安卓.apk"
EXPECTED_SHA = "f06d8e42131a3feb7a05e1e42244af43059a67899bf1fa958290f18d8106dc5a"
EXPECTED_CERT = "f0fd6c5b410f25cb25c3b53346c8972fae30f8ee7411df910480ad6b2d60db83"


def test_pinned_input():
    actual_sha = subprocess.check_output(["sha256sum", APK], text=True).split()[0]
    assert actual_sha == EXPECTED_SHA
    output = subprocess.check_output(["apksigner", "verify", "--print-certs", APK], text=True)
    assert f"Signer #1 certificate SHA-256 digest: {EXPECTED_CERT}" in output


def test_split_removal_is_idempotent():
    with tempfile.TemporaryDirectory() as directory:
        manifest = Path(directory) / "AndroidManifest.xml"
        with zipfile.ZipFile(APK) as archive:
            manifest.write_bytes(archive.read("AndroidManifest.xml"))
        before = manifest.read_bytes()
        subprocess.run([str(ROOT / "scripts/remove-required-split.py"), str(manifest)], check=True)
        assert manifest.read_bytes() == before


if __name__ == "__main__":
    test_pinned_input()
    test_split_removal_is_idempotent()
    print("build guard tests passed")
