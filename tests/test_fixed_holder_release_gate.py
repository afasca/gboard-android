#!/usr/bin/env python3
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path
import tempfile

ROOT = Path(__file__).resolve().parents[1]
GATE_PATH = ROOT / "scripts/verify-fixed-holder-contracts.py"
PATCHER_PATH = ROOT / "scripts/apply-smali-patches.py"
FIXTURES = ROOT / "tests/fixtures/gboard_17_8_5"

spec = spec_from_file_location("verify_fixed_holder_contracts", GATE_PATH)
gate = module_from_spec(spec)
spec.loader.exec_module(gate)
patcher_spec = spec_from_file_location("apply_smali_patches", PATCHER_PATH)
patcher = module_from_spec(patcher_spec)
patcher_spec.loader.exec_module(patcher)

def assert_rejected(action, expected):
    try:
        action()
    except SystemExit as error:
        assert expected in str(error)
    else:
        raise AssertionError("expected release verifier rejection")


def build_contract_tree(root: Path) -> None:
    files = {
        "smali_classes2/wsa.smali": FIXTURES / "wsa_attach.smali",
        "smali/wse.smali": FIXTURES / "wse_definition.smali",
        "smali_classes2/wsb.smali": FIXTURES / "wsb_run.smali",
        "smali/agxe.smali": FIXTURES / "agxe_power_key.smali",
        "smali/shb.smali": FIXTURES / "shb_voice.smali",
        "smali/wsf.smali": FIXTURES / "wsf_module.smali",
        "smali/wej.smali": FIXTURES / "wej_module.smali",
    }
    for relative, source in files.items():
        destination = root / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_text(source.read_text(encoding="utf-8"), encoding="utf-8")

    # Feed every patched contract through the production patcher.
    (root / "smali/wse.smali").write_text(
        patcher.patch_ai_polish_definition((root / "smali/wse.smali").read_text()),
        encoding="utf-8",
    )
    (root / "smali_classes2/wsb.smali").write_text(
        patcher.patch_ai_polish_click((root / "smali_classes2/wsb.smali").read_text()),
        encoding="utf-8",
    )
    (root / "smali/agxe.smali").write_text(
        patcher.patch_power_key_polish_default((root / "smali/agxe.smali").read_text()),
        encoding="utf-8",
    )
    (root / "smali/shb.smali").write_text(
        patcher.patch_voice_reserve_entry((root / "smali/shb.smali").read_text()),
        encoding="utf-8",
    )
    (root / "smali/wsf.smali").write_text(
        patcher.patch_polish_provider_module((root / "smali/wsf.smali").read_text()),
        encoding="utf-8",
    )
    (root / "smali/wej.smali").write_text(
        patcher.patch_ai_writing_tools_module((root / "smali/wej.smali").read_text()),
        encoding="utf-8",
    )

    non_customized = patcher.patch_non_customized_personalization(
        (FIXTURES / "agww_personalization.smali").read_text(encoding="utf-8")
    )
    customized = patcher.patch_customized_personalization(
        (FIXTURES / "agwo_personalization.smali").read_text(encoding="utf-8")
    )
    customized_order = patcher.patch_customized_order_persistence(
        (FIXTURES / "agrz_customized_order_load.smali").read_text(encoding="utf-8")
    )
    (root / "smali_classes3").mkdir(parents=True, exist_ok=True)
    (root / "smali_classes3/agww.smali").write_text(
        non_customized, encoding="utf-8"
    )
    (root / "smali_classes3/agwo.smali").write_text(customized, encoding="utf-8")
    (root / "smali/agrz.smali").write_text(customized_order, encoding="utf-8")

    (root / "smali/wtv.smali").write_text(
        ".method static constructor <clinit>()V\n"
        "    .locals 1\n"
        '    const-string v0, "jarvis"\n'
        "    return-void\n"
        ".end method\n",
        encoding="utf-8",
    )
    state = """.method public final k()V
    .locals 3
    iget-boolean v1, p0, Lwok;->k:Z
    iget-boolean v1, p0, Lwok;->b:Z
    iget-boolean v1, p0, Lwok;->d:Z
    invoke-static {v1}, Lwtz;->i(Z)Z
    iget-boolean v1, p0, Lwok;->c:Z
    iget-boolean v1, p0, Lwok;->m:Z
    const/4 v1, 0x3
    const/4 v2, 0x4
    const/4 v1, 0x6
    instance-of v1, p0, Lwsc;
    sget-object v1, Lwtu;->c:Lajoj;
    return-void
.end method
"""
    (root / "smali_classes2/wok.smali").write_text(state, encoding="utf-8")


def test_production_verify_accepts_complete_patched_contract_tree() -> None:
    with tempfile.TemporaryDirectory(prefix="fixed-holder-contract-", dir="/var/tmp") as directory:
        decoded = Path(directory)
        build_contract_tree(decoded)
        gate.verify(decoded)


def test_production_verify_rejects_late_customized_rejection() -> None:
    with tempfile.TemporaryDirectory(prefix="fixed-holder-contract-", dir="/var/tmp") as directory:
        decoded = Path(directory)
        build_contract_tree(decoded)
        path = decoded / "smali_classes3/agwo.smali"
        text = path.read_text(encoding="utf-8")
        text = text.replace(
            "    return-void\n\n    :vorflux_non_jarvis_feature",
            "    goto :vorflux_non_jarvis_feature\n\n    :vorflux_non_jarvis_feature",
            1,
        )
        assert "goto :vorflux_non_jarvis_feature" in text
        text = text.replace(
            "    return-void\n\n    .line 112",
            "    goto :cond_2\n\n    .line 112",
            1,
        )
        path.write_text(text, encoding="utf-8")
        assert_rejected(
            lambda: gate.verify(decoded),
            "Jarvis rejection does not return before customized Lagwn construction",
        )


def test_production_verify_rejects_register_drift() -> None:
    with tempfile.TemporaryDirectory(prefix="fixed-holder-contract-", dir="/var/tmp") as directory:
        decoded = Path(directory)
        build_contract_tree(decoded)
        path = decoded / "smali_classes3/agwo.smali"
        text = path.read_text(encoding="utf-8").replace(
            "    .locals 11", "    .locals 10", 1
        )
        path.write_text(text, encoding="utf-8")
        assert_rejected(
            lambda: gate.verify(decoded),
            "customized Jarvis rejection: insufficient local registers",
        )


def test_production_verify_rejects_non_customized_branch_inversion() -> None:
    with tempfile.TemporaryDirectory(prefix="fixed-holder-contract-", dir="/var/tmp") as directory:
        decoded = Path(directory)
        build_contract_tree(decoded)
        path = decoded / "smali_classes3/agww.smali"
        text = path.read_text(encoding="utf-8").replace(
            "    if-nez v1, :vorflux_no_high_investment_feature",
            "    if-eqz v1, :vorflux_no_high_investment_feature",
            1,
        )
        path.write_text(text, encoding="utf-8")
        assert_rejected(
            lambda: gate.verify(decoded),
            "non-customized high-investment rejection: patched method SHA-256 mismatch",
        )


def test_production_verify_rejects_customized_branch_inversion() -> None:
    with tempfile.TemporaryDirectory(prefix="fixed-holder-contract-", dir="/var/tmp") as directory:
        decoded = Path(directory)
        build_contract_tree(decoded)
        path = decoded / "smali_classes3/agwo.smali"
        text = path.read_text(encoding="utf-8").replace(
            "    if-eqz v4, :vorflux_non_jarvis_feature",
            "    if-nez v4, :vorflux_non_jarvis_feature",
            1,
        )
        path.write_text(text, encoding="utf-8")
        assert_rejected(
            lambda: gate.verify(decoded),
            "customized personalization update: patched method SHA-256 mismatch",
        )


def test_production_verify_rejects_missing_order_variant_migration() -> None:
    with tempfile.TemporaryDirectory(prefix="fixed-holder-contract-", dir="/var/tmp") as directory:
        decoded = Path(directory)
        build_contract_tree(decoded)
        path = decoded / "smali/agrz.smali"
        text = path.read_text(encoding="utf-8").replace(
            "    invoke-static {v4, v11, v8}, Lagrz;->o(Lanyg;II)V\n",
            "",
            1,
        )
        path.write_text(text, encoding="utf-8")
        assert_rejected(
            lambda: gate.verify(decoded),
            "missing persisted order migration: invoke-static {v4, v11, v8}, Lagrz;->o(Lanyg;II)V",
        )


def test_production_verify_rejects_wrong_order_count_key() -> None:
    with tempfile.TemporaryDirectory(prefix="fixed-holder-contract-", dir="/var/tmp") as directory:
        decoded = Path(directory)
        build_contract_tree(decoded)
        path = decoded / "smali/agrz.smali"
        text = path.read_text(encoding="utf-8").replace(
            "    const v8, 0x7f1409c6\n    invoke-static {v4, v11, v8}",
            "    const v8, 0x7f140934\n    invoke-static {v4, v11, v8}",
            1,
        )
        path.write_text(text, encoding="utf-8")
        assert_rejected(
            lambda: gate.verify(decoded),
            "missing persisted order migration: const v8, 0x7f1409c6",
        )


def test_production_verify_rejects_broken_active_prefix_comparison() -> None:
    with tempfile.TemporaryDirectory(prefix="fixed-holder-contract-", dir="/var/tmp") as directory:
        decoded = Path(directory)
        build_contract_tree(decoded)
        path = decoded / "smali/agrz.smali"
        text = path.read_text(encoding="utf-8").replace(
            "    if-ge v3, v6, :vorflux_customized_order_next",
            "    if-gt v3, v6, :vorflux_customized_order_next",
            1,
        )
        path.write_text(text, encoding="utf-8")
        assert_rejected(
            lambda: gate.verify(decoded),
            "missing persisted order scrub: if-ge v3, v6",
        )


def test_production_verify_rejects_altered_order_migration_helper() -> None:
    with tempfile.TemporaryDirectory(prefix="fixed-holder-contract-", dir="/var/tmp") as directory:
        decoded = Path(directory)
        build_contract_tree(decoded)
        path = decoded / "smali/agrz.smali"
        text = path.read_text(encoding="utf-8").replace(
            "    add-int/lit8 v4, v4, 0x1",
            "    add-int/lit8 v4, v4, 0x2",
            1,
        )
        path.write_text(text, encoding="utf-8")
        assert_rejected(
            lambda: gate.verify(decoded),
            "customized persisted order migration: patched method SHA-256 mismatch",
        )


def test_method_parser_rejects_duplicate_signature_and_missing_end() -> None:
    complete = ".method public final q()V\n    return-void\n.end method"
    assert_rejected(lambda: gate.method(complete + "\n" + complete, ".method public final q()V"), "expected exactly one method")
    assert_rejected(lambda: gate.method(complete[:-11], ".method public final q()V"), "method end not found")


def test_all_return_register_check_rejects_mismatch() -> None:
    method_text = (
        ".method private final w()Ljava/lang/String;\n"
        "    .locals 1\n"
        "    return-object v0\n"
        "    return-object v1\n"
        ".end method"
    )
    assert_rejected(
        lambda: gate.require_returns(
            method_text,
            ("return-object v0", "return-object p0"),
            "high-investment",
        ),
        "high-investment: return/register mismatch",
    )


def test_packaging_verifier_composes_behavior_gate_before_success() -> None:
    verifier = (ROOT / "scripts/verify-built-apk.sh").read_text(encoding="utf-8")
    gate_call = verifier.index('verify-fixed-holder-contracts.py')
    success = verifier.index('echo "verified $APK"')
    assert gate_call < success
    assert '--apktool "$APKTOOL_JAR" "$APK"' in verifier

    builder = (ROOT / "scripts/build-ai-gboard.sh").read_text(encoding="utf-8")
    packaging_call = builder.index('verify-built-apk.sh')
    final_move = builder.index('mv -f "$SIGNED_TMP" "$OUTPUT"')
    assert packaging_call < final_move
    assert 'APKTOOL_JAR="$APKTOOL_JAR"' in builder
    assert 'verify-fixed-holder-contracts.py' not in builder

if __name__ == "__main__":
    test_production_verify_accepts_complete_patched_contract_tree()
    test_production_verify_rejects_late_customized_rejection()
    test_production_verify_rejects_register_drift()
    test_production_verify_rejects_non_customized_branch_inversion()
    test_production_verify_rejects_customized_branch_inversion()
    test_production_verify_rejects_missing_order_variant_migration()
    test_production_verify_rejects_wrong_order_count_key()
    test_production_verify_rejects_broken_active_prefix_comparison()
    test_production_verify_rejects_altered_order_migration_helper()
    test_method_parser_rejects_duplicate_signature_and_missing_end()
    test_all_return_register_check_rejects_mismatch()
    test_packaging_verifier_composes_behavior_gate_before_success()
    print("fixed-holder release gate tests passed")
