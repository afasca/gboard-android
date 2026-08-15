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

EXPECTED_PATCH_OUTPUTS = {
    "smali/wsf.smali",
    "smali/wej.smali",
    "smali_classes2/wok.smali",
    "smali/wse.smali",
    "smali_classes2/wsb.smali",
    "smali/agxe.smali",
    "smali/agrz.smali",
    "smali_classes3/agww.smali",
    "smali_classes3/agwo.smali",
    "smali/shb.smali",
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

        wsf = method(
            outputs["smali/wsf.smali"],
            ".method public final getModuleDef(Landroid/content/Context;)Lamyy;",
        )
        wej = method(
            outputs["smali/wej.smali"],
            ".method public final getModuleDef(Landroid/content/Context;)Lamyy;",
        )
        assert "Lwtu;->r:Lajoj;" not in wsf
        assert "const-class v1, Lwth;" not in wsf
        assert "Lwtu;->c:Lajoj;" not in wej
        assert "const-class v1, Lwth;" not in wej
        assert "sget-object v1, Laliq;->c:Langv;" in wej

        lifecycle = (decoded / "smali_classes2/wsa.smali").read_text(
            encoding="utf-8"
        )
        lifecycle_method = method(
            lifecycle,
            ".method public final a(Lagpe;Landroid/view/View;)V",
        )
        assert "const/16 v1, -0x27f9" in lifecycle_method
        assert "Lwtz;->f(" not in lifecycle_method
        assert "Lakhf;->g:Lakhf;" not in lifecycle_method

        definition = method(
            outputs["smali/wse.smali"],
            ".method public final b(Ljava/lang/String;Z)Lagpb;",
        )
        assert 'const-string v1, "AI 润色"' in definition
        assert "const v0, 0x7f1406b9" in definition
        assert "const v0, 0x7f0804cc" in definition
        assert "new-instance v0, Lwsb;" in definition
        assert "Lagow;->u(Ljava/lang/Runnable;)V" in definition

        click = method(
            outputs["smali_classes2/wsb.smali"],
            ".method public final run()V",
        )
        assert "new-instance v3, Lwdz;" in click
        assert "Lj$/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;" in click
        assert "invoke-direct {v3, v2}, Lwdz;-><init>(Lajlf;)V" in click
        assert "sget-object v2, Lakhf;->g:Lakhf;" in click
        assert (
            "Lwtz;->f(Lajkj;Laodi;ZLakhf;Ljava/util/function/Consumer;)V"
            in click
        )

        holder = method(
            outputs["smali/agxe.smali"],
            ".method private static N(Landroid/content/Context;Lanyg;ZLaivh;)Ljava/lang/String;",
        )
        assert "const v0, 0x7f1404b3" in holder
        assert 'const-string v1, "voice"' in holder
        assert "Lanxc;->t(ILjava/lang/String;)V" in holder

        persisted_order = outputs["smali/agrz.smali"]
        persisted_load = method(
            persisted_order,
            ".method static n(Landroid/content/Context;Lagut;Laivh;Lazha;Lazha;Z)Lagrz;",
        )
        persisted_migration = method(
            persisted_order,
            ".method private static o(Lanyg;II)V",
        )
        for contract in (
            "const v8, 0x7f140934",
            "const v8, 0x7f1409c6",
            "invoke-static {v4, v5, v8}, Lagrz;->o(Lanyg;II)V",
            "invoke-static {v4, v11, v8}, Lagrz;->o(Lanyg;II)V",
        ):
            assert contract in persisted_load
        for contract in (
            'const-string v9, "jarvis"',
            "Landroid/text/TextUtils;->join(Ljava/lang/CharSequence;Ljava/lang/Iterable;)Ljava/lang/String;",
            "Lanxc;->t(ILjava/lang/String;)V",
            "Lanxc;->l(II)I",
            "Lanxc;->r(II)V",
        ):
            assert contract in persisted_migration

        non_customized = outputs["smali_classes3/agww.smali"]
        constructor = method(
            non_customized,
            ".method public constructor <init>(Landroid/content/Context;Lagsp;)V",
        )
        waiting_list = method(non_customized, ".method public static q()Lazha;")
        high_investment = method(
            non_customized,
            ".method private final w()Ljava/lang/String;",
        )
        assert 'const-string v3, "jarvis"' in constructor
        assert "const v3, 0x7f140ac1" in constructor
        assert "Ljava/util/Set;->remove(Ljava/lang/Object;)Z" in constructor
        assert 'const-string v2, "jarvis"' in waiting_list
        assert ":vorflux_remove_jarvis_waiting_list" in waiting_list
        assert "Ljava/util/List;->remove(Ljava/lang/Object;)Z" in waiting_list
        assert 'const-string v1, "jarvis"' in high_investment
        assert high_investment.index('const-string v1, "jarvis"') < high_investment.index(
            "Lagsp;->d(Ljava/lang/String;)Z"
        )

        customized = method(
            outputs["smali_classes3/agwo.smali"],
            ".method public final q()V",
        )
        assert customized.index(":vorflux_non_jarvis_feature") < customized.index(
            "new-instance v4, Lagwn;"
        )
        assert "iput-object v4, p0, Lagwo;->j:Lagwm;" in customized
        assert 'const-string v10, "jarvis:"' in customized
        assert "Ljava/util/Iterator;->remove()V" in customized
        assert "const v5, 0x7f140abf" in customized
        assert "Lanxc;->u(ILjava/util/Set;)V" in customized

        voice = method(
            outputs["smali/shb.smali"],
            ".method private final d(Z)Lagow;",
        )
        assert "Latbs;->g(Lagow;)V" in voice
        assert 'const-string v2, "default"' not in voice
        assert "Lsgw;-><init>(Lshb;Z)V" in voice
        assert "Lsgx;-><init>(Lshb;Z)V" in voice

        action_signature = ".method public final b(I)V"
        original_action = method(originals["smali/shb.smali"], action_signature)
        patched_action = method(outputs["smali/shb.smali"], action_signature)
        assert patched_action == original_action
        for native_contract in (
            "const/16 v6, -0x273a",
            "const/16 v6, -0x275b",
            "Latbs;->f(Lagow;Z)V",
        ):
            assert native_contract in original_action


if __name__ == "__main__":
    test_pinned_ai_polish_registration_patch()
    print("pinned smali patch integration test passed")
