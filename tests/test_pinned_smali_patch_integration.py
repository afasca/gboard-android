#!/usr/bin/env python3
import hashlib
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
APK = ROOT / "fused-gboard-安卓.apk"
APKTOOL = ROOT / "tools/apktool_2.12.0.jar"
PATCHER_PATH = ROOT / "scripts/apply-smali-patches.py"
EXPECTED_APK_SHA256 = "f06d8e42131a3feb7a05e1e42244af43059a67899bf1fa958290f18d8106dc5a"

spec = spec_from_file_location("apply_smali_patches", PATCHER_PATH)
patcher = module_from_spec(spec)
spec.loader.exec_module(patcher)

WQP_GATE = """    sget-object p1, Lwtu;->a:Lajoj;

    .line 57
    .line 58
    invoke-virtual {p0, p1}, Lamym;->k(Lajoj;)V

    .line 59
"""
WGW_GATE = """    sget-object p1, Lwtu;->a:Lajoj;

    .line 20
    .line 21
    invoke-virtual {p0, p1}, Lamym;->k(Lajoj;)V

    .line 22
"""
EXPECTED_PATCH_OUTPUTS = {
    "smali/agpc.smali",
    "smali/wqp.smali",
    "smali/wgw.smali",
    "smali/wsf.smali",
    "smali/wej.smali",
    "smali_classes2/wok.smali",
    "smali/wse.smali",
    "smali_classes2/wsa.smali",
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def method(text: str, signature: str) -> str:
    start = text.index(signature)
    end = text.index("\n.end method", start) + len("\n.end method")
    return text[start:end]


def decode_pinned_apk(output: Path) -> None:
    java = shutil.which("java")
    assert java, "java is required to run the pinned apktool integration test"
    assert APK.is_file(), f"missing pinned fused APK: {APK}"
    assert APKTOOL.is_file(), f"missing pinned apktool: {APKTOOL}"
    assert sha256(APK) == EXPECTED_APK_SHA256

    result = subprocess.run(
        [java, "-jar", str(APKTOOL), "d", "-r", str(APK), "-o", str(output)],
        text=True,
        capture_output=True,
    )
    assert result.returncode == 0, (
        "apktool decode failed\n"
        f"stdout:\n{result.stdout}\n"
        f"stderr:\n{result.stderr}"
    )


def test_pinned_ai_polish_registration_patch() -> None:
    with tempfile.TemporaryDirectory(
        prefix="gboard-pinned-smali-",
        dir="/var/tmp",
    ) as directory:
        decoded = Path(directory) / "decoded"
        decode_pinned_apk(decoded)

        originals = {
            relative: (decoded / relative).read_text(encoding="utf-8")
            for relative in EXPECTED_PATCH_OUTPUTS
        }
        patches = patcher.patch_ai_polish_entry(decoded)
        outputs = {
            path.relative_to(decoded).as_posix(): patched
            for path, patched in patches
        }

        assert len(outputs) == len(patches)
        assert set(outputs) == EXPECTED_PATCH_OUTPUTS
        for relative, patched in outputs.items():
            assert patched != originals[relative]
            (decoded / relative).write_text(patched, encoding="utf-8")
            assert (decoded / relative).read_text(encoding="utf-8") == patched

        wqp_before = originals["smali/wqp.smali"]
        wqp_after = (decoded / "smali/wqp.smali").read_text(encoding="utf-8")
        assert wqp_before.count(WQP_GATE) == 1
        assert wqp_after == wqp_before.replace(WQP_GATE, "    .line 59\n")

        wqp_module = method(
            wqp_after,
            ".method public final getModuleDef(Landroid/content/Context;)Lamyy;",
        )
        assert "sget-object v0, Lwgv;->a:Langv;" in wqp_module
        assert "invoke-virtual {p0, p1}, Lamym;->h([Langv;)V" in wqp_module

        wgw_before = originals["smali/wgw.smali"]
        wgw_after = (decoded / "smali/wgw.smali").read_text(encoding="utf-8")
        assert wgw_before.count(WGW_GATE) == 1
        assert wgw_after == wgw_before.replace(WGW_GATE, "    .line 22\n")

        wgw_factory = method(wgw_after, ".method public final a(Lamyb;)Lamyc;")
        assert "new-instance p0, Lwgv;" in wgw_factory
        assert "invoke-direct {p0}, Lwgv;-><init>()V" in wgw_factory

        wgw_module = method(
            wgw_after,
            ".method public final getModuleDef(Landroid/content/Context;)Lamyy;",
        )
        assert "const-class p0, Lwgv;" in wgw_module
        assert "const/16 v1, 0x8d" in wgw_module
        assert (
            "invoke-direct {v0, v1, p0, p0, p1}, "
            "Lamyw;-><init>(ILjava/lang/Class;Ljava/lang/Class;Lamyx;)V"
            in wgw_module
        )


if __name__ == "__main__":
    test_pinned_ai_polish_registration_patch()
    print("pinned smali patch integration test passed")
