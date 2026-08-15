#!/usr/bin/env python3
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PATCHER_PATH = ROOT / "scripts/apply-smali-patches.py"
FIXTURES = ROOT / "tests/fixtures/gboard_17_8_5"
spec = spec_from_file_location("apply_smali_patches", PATCHER_PATH)
patcher = module_from_spec(spec)
spec.loader.exec_module(patcher)


def method(text, signature):
    start = text.index(signature)
    end = text.index("\n.end method", start) + len("\n.end method")
    return text[start:end]


def test_polish_state_keeps_native_eligibility():
    original = """.method public final k()V
    .locals 4
    iget-object v0, p0, Lwok;->g:Lagpf;
    if-nez v0, :cond_0
    return-void
    :cond_0
    iget-boolean v1, p0, Lwok;->l:Z
    if-eqz v1, :cond_1
    const/4 v1, 0x3
    goto :goto_0
    :cond_1
    iget-boolean v1, p0, Lwok;->k:Z
    const/4 v2, 0x4
    if-eqz v1, :cond_4
    iget-boolean v1, p0, Lwok;->b:Z
    if-eqz v1, :cond_4
    iget-boolean v1, p0, Lwok;->d:Z
    invoke-static {v1}, Lwtz;->i(Z)Z
    move-result v1
    if-eqz v1, :cond_4
    iget-boolean v1, p0, Lwok;->c:Z
    if-nez v1, :cond_2
    iget-boolean v1, p0, Lwok;->m:Z
    if-nez v1, :cond_4
    :cond_2
    sget-object v1, Lwtu;->c:Lajoj;
    invoke-interface {v1}, Lajoj;->g()Ljava/lang/Object;
    move-result-object v2
    check-cast v2, Ljava/lang/Boolean;
    invoke-virtual {v2}, Ljava/lang/Boolean;->booleanValue()Z
    move-result v2
    const/4 v3, 0x2
    if-nez v2, :cond_3
    invoke-interface {v1}, Lajoj;->a()I
    move-result v1
    if-ne v1, v3, :cond_3
    const/4 v1, 0x6
    goto :goto_0
    :cond_3
    move v1, v3
    goto :goto_0
    :cond_4
    move v1, v2
    :goto_0
    iput v1, p0, Lwok;->e:I
    invoke-virtual {v0, v1}, Lagpf;->b(I)V
    invoke-virtual {p0, v1}, Lwok;->l(I)V
    return-void
.end method"""
    replacement = """    :cond_2
    instance-of v1, p0, Lwsc;
    if-eqz v1, :vorflux_polish_original_gate

    const/4 v1, 0x2
    goto :goto_0

    :vorflux_polish_original_gate
    sget-object v1, Lwtu;->c:Lajoj;
"""
    expected = original.replace(
        """    :cond_2
    sget-object v1, Lwtu;->c:Lajoj;
""",
        replacement,
    )
    patched = patcher.patch_polish_state_eligibility(original)
    assert patched == expected
    for guard in (
        "Lwok;->k:Z",
        "Lwok;->b:Z",
        "Lwok;->d:Z",
        "Lwtz;->i(Z)Z",
        "Lwok;->c:Z",
        "Lwok;->m:Z",
        "Lwtu;->c:Lajoj;",
        "const/4 v1, 0x3",
        "const/4 v2, 0x4",
        "const/4 v1, 0x6",
    ):
        assert guard in patched
    assert "instance-of v1, p0, Lwsc;" in patched
    assert "Lwqf;" not in patched


def test_polish_click_uses_runnable_and_preserves_lifecycle_callback():
    lifecycle = (FIXTURES / "wsa_attach.smali").read_text(encoding="utf-8")
    lifecycle_method = method(
        lifecycle,
        ".method public final a(Lagpe;Landroid/view/View;)V",
    )
    assert "const/16 v1, -0x27f9" in lifecycle_method
    assert "Lwtz;->f(" not in lifecycle_method
    assert "Lakhf;->g:Lakhf;" not in lifecycle_method

    definition = (FIXTURES / "wse_definition.smali").read_text(encoding="utf-8")
    patched_definition = patcher.patch_ai_polish_definition(definition)
    definition_method = method(
        patched_definition,
        ".method public final b(Ljava/lang/String;Z)Lagpb;",
    )
    assert 'const-string v1, "AI 润色"' in definition_method
    assert "const v0, 0x7f1406b9" in definition_method
    assert "const v0, 0x7f0804cc" in definition_method
    assert "new-instance v0, Lwsb;" in definition_method
    assert "Lagow;->u(Ljava/lang/Runnable;)V" in definition_method

    runnable = (FIXTURES / "wsb_run.smali").read_text(encoding="utf-8")
    click = method(patcher.patch_ai_polish_click(runnable), ".method public final run()V")
    assert "invoke-virtual {p0}, Lajki;->ae()Lajlf;" in click
    assert "new-instance v3, Lwdz;" in click
    assert "Lj$/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;" in click
    assert "sget-object v2, Lakhf;->g:Lakhf;" in click
    assert "Lwtz;->f(Lajkj;Laodi;ZLakhf;Ljava/util/function/Consumer;)V" in click


def test_polish_registration_removes_only_unused_helper_dependencies_and_gates():
    wsf = (FIXTURES / "wsf_module.smali").read_text(encoding="utf-8")
    wej = (FIXTURES / "wej_module.smali").read_text(encoding="utf-8")
    patched_wsf = method(
        patcher.patch_polish_provider_module(wsf),
        ".method public final getModuleDef(Landroid/content/Context;)Lamyy;",
    )
    patched_wej = method(
        patcher.patch_ai_writing_tools_module(wej),
        ".method public final getModuleDef(Landroid/content/Context;)Lamyy;",
    )
    assert "const-class p0, Lwse;" in patched_wsf
    assert "const-class v1, Lwth;" not in patched_wsf
    assert "Lwtu;->r:Lajoj;" not in patched_wsf
    assert "const-class p1, Lwtj;" in patched_wej
    assert "const-class v1, Lwth;" not in patched_wej
    assert "Lwtu;->c:Lajoj;" not in patched_wej
    assert "sget-object v1, Laliq;->c:Langv;" in patched_wej
    assert "sget-object v1, Laooc;->a:Laooc;" in patched_wej


def test_fixed_holder_migrates_voice_while_native_voice_remains_intact():
    holder = (FIXTURES / "agxe_power_key.smali").read_text(encoding="utf-8")
    patched_holder = method(
        patcher.patch_power_key_polish_default(holder),
        ".method private static N(Landroid/content/Context;Lanyg;ZLaivh;)Ljava/lang/String;",
    )
    assert "const v0, 0x7f1404b3" in patched_holder
    assert 'const-string v1, "voice"' in patched_holder
    assert "Lanxc;->o(ILjava/lang/String;)Ljava/lang/String;" in patched_holder
    assert "Lanxc;->t(ILjava/lang/String;)V" in patched_holder

    voice = (FIXTURES / "shb_voice.smali").read_text(encoding="utf-8")
    patched_voice = patcher.patch_voice_reserve_entry(voice)
    voice_builder = method(patched_voice, ".method private final d(Z)Lagow;")
    assert "Latbs;->g(Lagow;)V" in voice_builder
    assert 'const-string v2, "default"' not in voice_builder
    assert "Lsgw;-><init>(Lshb;Z)V" in voice_builder
    assert "Lsgx;-><init>(Lshb;Z)V" in voice_builder
    for native_contract in (
        "const/16 v6, -0x273a",
        "const/16 v6, -0x275b",
        "Latbs;->f(Lagow;Z)V",
    ):
        assert native_contract in voice
        assert native_contract in patched_voice


def test_polish_stays_out_of_customizable_active_order():
    patcher_source = PATCHER_PATH.read_text()
    polish_section = patcher_source[
        patcher_source.index("def patch_ai_polish_entry") :
        patcher_source.index("def patch_translation_progress")
    ]
    assert "agpc.smali" not in polish_section
    assert "agsr.smali" not in polish_section
    assert "patch_toolbar_jarvis_persistence" not in patcher_source


if __name__ == "__main__":
    test_polish_state_keeps_native_eligibility()
    test_polish_click_uses_runnable_and_preserves_lifecycle_callback()
    test_polish_registration_removes_only_unused_helper_dependencies_and_gates()
    test_fixed_holder_migrates_voice_while_native_voice_remains_intact()
    test_polish_stays_out_of_customizable_active_order()
    print("smali patch regression tests passed")
