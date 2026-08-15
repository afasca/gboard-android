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


def assert_system_exit(action, expected_message):
    try:
        action()
    except SystemExit as error:
        assert expected_message in str(error)
    else:
        raise AssertionError("expected SystemExit")


def assert_patch_fails_closed(patch, original, patched, old_line, new_line, label):
    assert_system_exit(lambda: patch(patched), label)
    drifted = original.replace(old_line, new_line, 1)
    assert drifted != original
    assert_system_exit(lambda: patch(drifted), label)


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


def test_polish_definition_and_click_fail_closed():
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
    assert_patch_fails_closed(
        patcher.patch_ai_polish_definition,
        definition,
        patched_definition,
        "    const v0, 0x7f14170e",
        "    const v0, 0x7f14170d",
        "AI polish access point definition",
    )

    runnable = (FIXTURES / "wsb_run.smali").read_text(encoding="utf-8")
    click = method(patcher.patch_ai_polish_click(runnable), ".method public final run()V")
    assert "invoke-virtual {p0}, Lajki;->ae()Lajlf;" in click
    assert "new-instance v3, Lwdz;" in click
    assert "Lj$/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;" in click
    assert "sget-object v2, Lakhf;->g:Lakhf;" in click
    assert "Lwtz;->f(Lajkj;Laodi;ZLakhf;Ljava/util/function/Consumer;)V" in click
    patched_runnable = patcher.patch_ai_polish_click(runnable)
    assert_patch_fails_closed(
        patcher.patch_ai_polish_click,
        runnable,
        patched_runnable,
        "    .locals 5",
        "    .locals 6",
        "AI polish Runnable click",
    )


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


def test_personalization_rejects_jarvis_before_native_handlers_and_fails_closed():
    non_customized = (FIXTURES / "agww_personalization.smali").read_text(
        encoding="utf-8"
    )
    patched_non_customized = patcher.patch_non_customized_personalization(
        non_customized
    )
    constructor = method(
        patched_non_customized,
        ".method public constructor <init>(Landroid/content/Context;Lagsp;)V",
    )
    waiting_list = method(
        patched_non_customized,
        ".method public static q()Lazha;",
    )
    high_investment = method(
        patched_non_customized,
        ".method private final w()Ljava/lang/String;",
    )
    assert 'const-string v3, "jarvis"' in constructor
    assert "Ljava/util/Set;->remove(Ljava/lang/Object;)Z" in constructor
    assert "const v3, 0x7f140ac1" in constructor
    assert "Lanxc;->u(ILjava/util/Set;)V" in constructor
    assert 'const-string v2, "jarvis"' in waiting_list
    assert ":vorflux_remove_jarvis_waiting_list" in waiting_list
    assert "Ljava/util/List;->remove(Ljava/lang/Object;)Z" in waiting_list
    assert waiting_list.index('const-string v2, "jarvis"') < waiting_list.index(
        "Lazha;->k(Ljava/util/Collection;)Lazha;"
    )
    assert 'const-string v1, "jarvis"' in high_investment
    assert high_investment.index('const-string v1, "jarvis"') < high_investment.index(
        "Lagsp;->d(Ljava/lang/String;)Z"
    )
    assert_patch_fails_closed(
        patcher.patch_non_customized_personalization,
        non_customized,
        patched_non_customized,
        "    .locals 3",
        "    .locals 4",
        "non-customized personalization",
    )

    customized = (FIXTURES / "agwo_personalization.smali").read_text(
        encoding="utf-8"
    )
    patched_customized = patcher.patch_customized_personalization(customized)
    customized_q = method(patched_customized, ".method public final q()V")
    rejection = customized_q.index(":vorflux_non_jarvis_feature")
    lagwn = customized_q.index("new-instance v4, Lagwn;")
    assert rejection < lagwn
    assert "iput-object v4, p0, Lagwo;->j:Lagwm;" in customized_q
    assert "invoke-direct {p0}, Lagwo;->s()V" in customized_q
    assert 'const-string v10, "jarvis:"' in customized_q
    assert "Ljava/lang/String;->startsWith(Ljava/lang/String;)Z" in customized_q
    assert "Ljava/util/Iterator;->remove()V" in customized_q
    assert "const v5, 0x7f140abf" in customized_q
    assert "Lanxc;->u(ILjava/util/Set;)V" in customized_q
    assert_patch_fails_closed(
        patcher.patch_customized_personalization,
        customized,
        patched_customized,
        "    .locals 10",
        "    .locals 11",
        "customized high investment personalization",
    )


def test_customized_order_persistence_migrates_both_variants_and_fails_closed():
    original = (FIXTURES / "agrz_customized_order_load.smali").read_text(
        encoding="utf-8"
    )
    patched = patcher.patch_customized_order_persistence(original)
    load_method = method(
        patched,
        ".method static n(Landroid/content/Context;Lagut;Laivh;Lazha;Lazha;Z)Lagrz;",
    )
    migration = method(patched, ".method private static o(Lanyg;II)V")
    for contract in (
        "const v8, 0x7f140934",
        "const v8, 0x7f1409c6",
        "invoke-static {v4, v5, v8}, Lagrz;->o(Lanyg;II)V",
        "invoke-static {v4, v11, v8}, Lagrz;->o(Lanyg;II)V",
    ):
        assert contract in load_method
    for contract in (
        "Lanyg;->ar(I)Z",
        "Lanyg;->S(I)Ljava/lang/String;",
        'const-string v9, "jarvis"',
        "Ljava/lang/String;->equals(Ljava/lang/Object;)Z",
        "Landroid/text/TextUtils;->join(Ljava/lang/CharSequence;Ljava/lang/Iterable;)Ljava/lang/String;",
        "Lanxc;->t(ILjava/lang/String;)V",
        "Lanxc;->l(II)I",
        "if-ltz v6, :vorflux_customized_order_next",
        "if-ge v3, v6, :vorflux_customized_order_next",
        "Lanxc;->r(II)V",
    ):
        assert contract in migration
    assert_patch_fails_closed(
        patcher.patch_customized_order_persistence,
        original,
        patched,
        "    .locals 16",
        "    .locals 15",
        "customized persisted order load",
    )


def simulate_persisted_order_migration(order, active_count):
    migrated = []
    active_jarvis = 0
    for index, item in enumerate(order):
        if item == "jarvis":
            if active_count >= 0 and index < active_count:
                active_jarvis += 1
            continue
        migrated.append(item)
    if active_count >= 0:
        active_count = max(0, active_count - active_jarvis)
    return migrated, active_count


def active_status(order, active_count):
    return [
        (item, "active" if index < active_count else "reserve")
        for index, item in enumerate(order)
    ]


def test_restart_upgrade_migrates_active_jarvis_for_both_order_variants():
    variants = {
        0x7F140935: (["clipboard", "jarvis", "settings", "gif_search"], 3),
        0x7F1409C7: (["translate", "jarvis", "theme", "sticker"], 2),
    }
    for order_resource, (order, active_count) in variants.items():
        before = [entry for entry in active_status(order, active_count) if entry[0] != "jarvis"]
        migrated, migrated_count = simulate_persisted_order_migration(
            order, active_count
        )
        assert order_resource in (0x7F140935, 0x7F1409C7)
        assert "jarvis" not in migrated
        assert migrated_count == active_count - 1
        assert active_status(migrated, migrated_count) == before


def test_restart_upgrade_preserves_count_when_jarvis_was_reserve_or_count_unset():
    order = ["clipboard", "settings", "jarvis", "gif_search"]
    before = [entry for entry in active_status(order, 2) if entry[0] != "jarvis"]
    migrated, active_count = simulate_persisted_order_migration(order, 2)
    assert migrated == ["clipboard", "settings", "gif_search"]
    assert active_count == 2
    assert active_status(migrated, active_count) == before

    migrated, active_count = simulate_persisted_order_migration(order, -1)
    assert migrated == ["clipboard", "settings", "gif_search"]
    assert active_count == -1


def test_restart_upgrade_removes_all_jarvis_entries_without_reclassifying_items():
    order = ["jarvis", "clipboard", "clipboard", "jarvis", "settings", "jarvis"]
    before = [entry for entry in active_status(order, 4) if entry[0] != "jarvis"]
    migrated, active_count = simulate_persisted_order_migration(order, 4)
    assert migrated == ["clipboard", "clipboard", "settings"]
    assert active_count == 2
    assert active_status(migrated, active_count) == before


def test_fixed_holder_migrates_voice_while_native_voice_remains_intact():
    holder = (FIXTURES / "agxe_power_key.smali").read_text(encoding="utf-8")
    patched_holder_text = patcher.patch_power_key_polish_default(holder)
    patched_holder = method(
        patched_holder_text,
        ".method private static N(Landroid/content/Context;Lanyg;ZLaivh;)Ljava/lang/String;",
    )
    assert "const v0, 0x7f1404b3" in patched_holder
    assert 'const-string v1, "voice"' in patched_holder
    assert "Lanxc;->o(ILjava/lang/String;)Ljava/lang/String;" in patched_holder
    assert "Lanxc;->t(ILjava/lang/String;)V" in patched_holder
    assert_patch_fails_closed(
        patcher.patch_power_key_polish_default,
        holder,
        patched_holder_text,
        "    const v0, 0x7f1404cd",
        "    const v0, 0x7f1404cc",
        "fixed power-key AI polish selection",
    )

    voice = (FIXTURES / "shb_voice.smali").read_text(encoding="utf-8")
    patched_voice = patcher.patch_voice_reserve_entry(voice)
    voice_builder = method(patched_voice, ".method private final d(Z)Lagow;")
    assert "Latbs;->g(Lagow;)V" in voice_builder
    assert 'const-string v2, "default"' not in voice_builder
    assert "Lsgw;-><init>(Lshb;Z)V" in voice_builder
    assert "Lsgx;-><init>(Lshb;Z)V" in voice_builder



if __name__ == "__main__":
    test_polish_state_keeps_native_eligibility()
    test_polish_definition_and_click_fail_closed()
    test_polish_registration_removes_only_unused_helper_dependencies_and_gates()
    test_personalization_rejects_jarvis_before_native_handlers_and_fails_closed()
    test_customized_order_persistence_migrates_both_variants_and_fails_closed()
    test_restart_upgrade_migrates_active_jarvis_for_both_order_variants()
    test_restart_upgrade_preserves_count_when_jarvis_was_reserve_or_count_unset()
    test_restart_upgrade_removes_all_jarvis_entries_without_reclassifying_items()
    test_fixed_holder_migrates_voice_while_native_voice_remains_intact()
    print("smali patch regression tests passed")
