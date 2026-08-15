#!/usr/bin/env python3
import hashlib
import sys
from collections.abc import Callable
from pathlib import Path


def unique_index(text: str, needle: str, label: str) -> int:
    count = text.count(needle)
    if count != 1:
        raise SystemExit(f"{label}: expected exactly one match, found {count}")
    return text.index(needle)


def replace_once(text: str, old: str, new: str, label: str) -> str:
    start = unique_index(text, old, label)
    return text[:start] + new + text[start + len(old) :]


def replace_range_once(
    text: str,
    start_marker: str,
    end_marker: str,
    replacement: str,
    label: str,
) -> str:
    start = unique_index(text, start_marker, f"{label} start")
    end = unique_index(text, end_marker, f"{label} end")
    if end <= start:
        raise SystemExit(f"{label}: end marker precedes start marker")
    return text[:start] + replacement + text[end:]


def update_method_once(
    text: str,
    signature: str,
    update: Callable[[str], str],
    label: str,
) -> str:
    start = unique_index(text, signature, f"{label} method")
    end = text.find("\n.end method", start)
    next_method = text.find("\n.method ", start + len(signature))
    if end == -1 or (next_method != -1 and next_method < end):
        raise SystemExit(f"{label}: method end not found")
    end += len("\n.end method")
    method = text[start:end]
    return text[:start] + update(method) + text[end:]


def load(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def validate_method_sha256(method: str, expected_sha256: str, label: str) -> None:
    actual_sha256 = hashlib.sha256(method.encode("utf-8")).hexdigest()
    if actual_sha256 != expected_sha256:
        raise SystemExit(
            f"{label}: original method SHA-256 mismatch "
            f"(expected {expected_sha256}, found {actual_sha256})"
        )


def replace_verified_method(
    method: str,
    expected_sha256: str,
    replacement: str,
    label: str,
) -> str:
    validate_method_sha256(method, expected_sha256, label)
    return replacement


def patch_development_certificate(root: Path) -> tuple[Path, str]:
    path = root / "smali/aqlc.smali"
    text = load(path)
    needle = """    sput-object v0, Laqlc;->a:[B

    .line 38
"""
    replacement = """    sput-object v0, Laqlc;->a:[B

    const/16 v0, 0x20
    new-array v1, v0, [B
    fill-array-data v1, :array_vorflux_dev
    sput-object v1, Laqlc;->c:[B

    .line 38
"""
    data = """
    :array_vorflux_dev
    .array-data 1
        0x72t
        -0xdt
        0x57t
        -0x6dt
        -0x17t
        -0xft
        0x7at
        -0x46t
        0x29t
        0x2ft
        -0x1at
        -0x23t
        0x16t
        0x7t
        -0x14t
        -0x5at
        -0x49t
        -0x7dt
        -0x31t
        0x77t
        -0x64t
        -0x5bt
        0x2bt
        0x15t
        0x61t
        -0x10t
        0x3et
        0x5bt
        -0x3ct
        0x11t
        -0x15t
        -0x15t
    .end array-data
"""
    patched = replace_once(text, needle, replacement, "development certificate assignment")
    patched = replace_once(patched, "\n.end method\n\n.method public static a(", data + "\n.end method\n\n.method public static a(", "development certificate data")
    return path, patched


def patch_translation_provider(root: Path) -> tuple[Path, str]:
    path = root / "smali/aciv.smali"
    text = load(path)

    def update(method: str) -> str:
        replacement = """    new-instance p3, Lcom/vorflux/gboardai/AiTranslateProvider;

    iget-object v0, p0, Laciv;->c:Landroid/content/Context;

    invoke-direct {p3, v0}, Lcom/vorflux/gboardai/AiTranslateProvider;-><init>(Landroid/content/Context;)V

    iput-object p3, p0, Laciv;->p:Lacgc;
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_0

    goto :goto_5

"""
        return replace_range_once(
            method,
            "    sget p3, Landroid/os/Build$VERSION;->SDK_INT:I",
            "    :cond_7\n    :goto_5",
            replacement,
            "translation provider body",
        )

    patched = update_method_once(
        text,
        ".method public final declared-synchronized o(",
        update,
        "translation provider",
    )
    return path, patched


def patch_ai_polish_flow(root: Path) -> tuple[Path, str]:
    path = root / "smali/wei.smali"
    text = load(path)
    needle = """    move-object/from16 v2, p2

    .line 6
    .line 7
    sget-object v3, Lakhf;->f:Lakhf;
"""
    replacement = """    move-object/from16 v2, p2

    sget-object v3, Lakhf;->g:Lakhf;
    if-ne v1, v3, :ai_original
    const/4 v5, 0x1
    invoke-virtual {v0, v5}, Lwei;->w(Z)Lakyz;
    move-result-object v4
    iput-object v4, v0, Lwei;->u:Lakyz;
    if-eqz v4, :ai_empty
    invoke-virtual {v4}, Lakyz;->p()Z
    move-result v3
    if-nez v3, :ai_empty
    invoke-virtual {v4}, Lakyz;->o()Z
    move-result v3
    if-eqz v3, :ai_whole
    invoke-virtual {v4}, Lakyz;->l()Ljava/lang/CharSequence;
    move-result-object v3
    goto :ai_text_ready
    :ai_whole
    invoke-virtual {v4}, Lakyz;->toString()Ljava/lang/String;
    move-result-object v3
    :ai_text_ready
    invoke-interface {v3}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v0}, Lajki;->ab()Landroid/content/Context;
    move-result-object v4
    invoke-static {v4, v3}, Lcom/vorflux/gboardai/AiWritingTools;->polish(Landroid/content/Context;Ljava/lang/String;)Ljava/util/concurrent/Future;
    move-result-object v3
    new-instance v4, Lcom/vorflux/gboardai/AiPolishFuture;
    invoke-direct {v4, v3}, Lcom/vorflux/gboardai/AiPolishFuture;-><init>(Ljava/util/concurrent/Future;)V
    return-object v4
    :ai_empty
    sget-object v3, Lazlj;->a:Lazfk;
    invoke-static {v3}, Lbayl;->h(Ljava/lang/Object;)Lbazc;
    move-result-object v3
    return-object v3
    :ai_original

    .line 6
    .line 7
    sget-object v3, Lakhf;->f:Lakhf;
"""
    return path, replace_once(text, needle, replacement, "AI polish flow")


def patch_translation_settings(root: Path) -> tuple[Path, str]:
    path = (
        root
        / "smali_classes2/com/google/android/apps/inputmethod/libs/autotranslate/AutoTranslatePreferenceFragment.smali"
    )
    text = replace_once(
        load(path),
        ".field private ak:Lcom/google/android/apps/inputmethod/libs/translate/SystemTranslateProvider;",
        ".field private ak:Lacgc;",
        "translation settings provider field",
    )

    def patch_settings_method(method: str) -> str:
        method = replace_once(
            method,
            "    .locals 2",
            "    .locals 3",
            "translation settings local count",
        )
        needle = """    invoke-super {p0}, Lcom/google/android/libraries/inputmethod/preferencewidgets/CommonPreferenceFragment;->ac()V

    .line 2
"""
        insertion = """    invoke-super {p0}, Lcom/google/android/libraries/inputmethod/preferencewidgets/CommonPreferenceFragment;->ac()V

    invoke-virtual {p0}, Leaq;->n()Landroidx/preference/PreferenceScreen;
    move-result-object v0
    const-string v2, "gboard_ai_settings"
    invoke-virtual {v0, v2}, Landroidx/preference/PreferenceGroup;->l(Ljava/lang/CharSequence;)Landroidx/preference/Preference;
    move-result-object v1
    if-nez v1, :ai_settings_done

    invoke-virtual {p0}, Lbi;->x()Landroid/content/Context;
    move-result-object v0
    new-instance v1, Landroidx/preference/Preference;
    invoke-direct {v1, v0}, Landroidx/preference/Preference;-><init>(Landroid/content/Context;)V
    const-string v2, "MyBoard AI · OpenAI 兼容设置"
    invoke-virtual {v1, v2}, Landroidx/preference/Preference;->V(Ljava/lang/CharSequence;)V
    const-string v2, "API、模型、翻译防抖/提示词与 AI 润色风格"
    invoke-virtual {v1, v2}, Landroidx/preference/Preference;->n(Ljava/lang/CharSequence;)V
    const-string v2, "gboard_ai_settings"
    invoke-virtual {v1, v2}, Landroidx/preference/Preference;->P(Ljava/lang/String;)V
    new-instance v2, Lcom/vorflux/gboardai/AiSettingsClick;
    invoke-direct {v2, v0}, Lcom/vorflux/gboardai/AiSettingsClick;-><init>(Landroid/content/Context;)V
    iput-object v2, v1, Landroidx/preference/Preference;->o:Leaf;
    invoke-virtual {p0}, Leaq;->n()Landroidx/preference/PreferenceScreen;
    move-result-object v0
    invoke-virtual {v0, v1}, Landroidx/preference/PreferenceGroup;->an(Landroidx/preference/Preference;)V
    :ai_settings_done

    .line 2
"""
        return replace_once(method, needle, insertion, "translation settings preference")

    text = update_method_once(
        text,
        ".method public final ac()V",
        patch_settings_method,
        "translation settings",
    )

    def patch_provider_method(method: str) -> str:
        replacements = (
            (
                "    iget-object v1, p0, Lcom/google/android/apps/inputmethod/libs/autotranslate/AutoTranslatePreferenceFragment;->ak:Lcom/google/android/apps/inputmethod/libs/translate/SystemTranslateProvider;",
                "    iget-object v1, p0, Lcom/google/android/apps/inputmethod/libs/autotranslate/AutoTranslatePreferenceFragment;->ak:Lacgc;",
                "translation settings provider read",
            ),
            (
                "    new-instance v1, Lcom/google/android/apps/inputmethod/libs/translate/SystemTranslateProvider;",
                "    new-instance v1, Lcom/vorflux/gboardai/AiTranslateProvider;",
                "translation settings provider construction",
            ),
            (
                "    invoke-direct {v1, v0}, Lcom/google/android/apps/inputmethod/libs/translate/SystemTranslateProvider;-><init>(Landroid/content/Context;)V",
                "    invoke-direct {v1, v0}, Lcom/vorflux/gboardai/AiTranslateProvider;-><init>(Landroid/content/Context;)V",
                "translation settings provider constructor",
            ),
            (
                "    iput-object v1, p0, Lcom/google/android/apps/inputmethod/libs/autotranslate/AutoTranslatePreferenceFragment;->ak:Lcom/google/android/apps/inputmethod/libs/translate/SystemTranslateProvider;",
                "    iput-object v1, p0, Lcom/google/android/apps/inputmethod/libs/autotranslate/AutoTranslatePreferenceFragment;->ak:Lacgc;",
                "translation settings provider write",
            ),
            (
                "    invoke-virtual {v1, v2, v3}, Lcom/google/android/apps/inputmethod/libs/translate/SystemTranslateProvider;->b(Ljava/util/Locale;Lacga;)V",
                "    invoke-interface {v1, v2, v3}, Lacgc;->b(Ljava/util/Locale;Lacga;)V",
                "translation settings provider call",
            ),
        )
        for old, new, label in replacements:
            method = replace_once(method, old, new, label)
        return method

    patched = update_method_once(
        text,
        ".method protected final eu()V",
        patch_provider_method,
        "translation settings provider",
    )
    return path, patched


def patch_always_reachable_ai_settings(root: Path) -> tuple[Path, str]:
    path = (
        root
        / "smali_classes2/com/google/android/apps/inputmethod/latin/preference/PreferencesSettingsFragment.smali"
    )
    text = load(path)
    insertion = """
.method public final ac()V
    .locals 3

    invoke-super {p0}, Lcom/google/android/libraries/inputmethod/preferencewidgets/CommonPreferenceFragment;->ac()V

    invoke-virtual {p0}, Leaq;->n()Landroidx/preference/PreferenceScreen;
    move-result-object v0
    const-string v2, "gboard_ai_settings"
    invoke-virtual {v0, v2}, Landroidx/preference/PreferenceGroup;->l(Ljava/lang/CharSequence;)Landroidx/preference/Preference;
    move-result-object v1
    if-nez v1, :ai_settings_done

    invoke-virtual {p0}, Lbi;->x()Landroid/content/Context;
    move-result-object v0
    new-instance v1, Landroidx/preference/Preference;
    invoke-direct {v1, v0}, Landroidx/preference/Preference;-><init>(Landroid/content/Context;)V
    const-string v2, "MyBoard AI · OpenAI 兼容设置"
    invoke-virtual {v1, v2}, Landroidx/preference/Preference;->V(Ljava/lang/CharSequence;)V
    const-string v2, "API、模型、翻译防抖/提示词与 AI 润色风格"
    invoke-virtual {v1, v2}, Landroidx/preference/Preference;->n(Ljava/lang/CharSequence;)V
    const-string v2, "gboard_ai_settings"
    invoke-virtual {v1, v2}, Landroidx/preference/Preference;->P(Ljava/lang/String;)V
    new-instance v2, Lcom/vorflux/gboardai/AiSettingsClick;
    invoke-direct {v2, v0}, Lcom/vorflux/gboardai/AiSettingsClick;-><init>(Landroid/content/Context;)V
    iput-object v2, v1, Landroidx/preference/Preference;->o:Leaf;
    invoke-virtual {p0}, Leaq;->n()Landroidx/preference/PreferenceScreen;
    move-result-object v0
    invoke-virtual {v0, v1}, Landroidx/preference/PreferenceGroup;->an(Landroidx/preference/Preference;)V
    :ai_settings_done

    return-void
.end method
"""
    return path, replace_once(
        text,
        "\n# virtual methods\n",
        "\n# virtual methods\n" + insertion,
        "always-reachable AI settings preference",
    )


def patch_polish_state_eligibility(text: str) -> str:
    """Bypass the module gate only for the polish fixed-holder provider.

    The original editor/context checks remain authoritative. This avoids making
    Writing Tools available in password, incognito, or unsupported editors.
    """

    def update(method: str) -> str:
        needle = """    :cond_2
    sget-object v1, Lwtu;->c:Lajoj;
"""
        replacement = """    :cond_2
    instance-of v1, p0, Lwsc;
    if-eqz v1, :vorflux_polish_original_gate

    const/4 v1, 0x2
    goto :goto_0

    :vorflux_polish_original_gate
    sget-object v1, Lwtu;->c:Lajoj;
"""
        return replace_once(
            method,
            needle,
            replacement,
            "targeted AI polish state feature gate",
        )

    return update_method_once(
        text,
        ".method public final k()V",
        update,
        "targeted AI polish state feature gate",
    )


def patch_polish_provider_module(text: str) -> str:
    """Register the polish access point without the full Jarvis helper module."""

    def update(method: str) -> str:
        dependency = """    const/4 p1, 0x1

    .line 20
    new-array p1, p1, [Ljava/lang/Class;

    .line 21
    .line 22
    const-class v1, Lwth;

    .line 23
    .line 24
    const/4 v2, 0x0

    .line 25
    aput-object v1, p1, v2

    .line 26
    .line 27
    invoke-virtual {p0, p1}, Lamym;->g([Ljava/lang/Class;)V

    .line 28
    .line 29
    .line 30
"""
        gate = """    sget-object p1, Lwtu;->r:Lajoj;

    .line 31
    .line 32
    invoke-virtual {p0, p1}, Lamym;->k(Lajoj;)V

    .line 33
"""
        method = replace_once(
            method,
            dependency,
            "    .line 30\n",
            "AI polish unused Jarvis helper dependency",
        )
        return replace_once(
            method,
            gate,
            "    .line 33\n",
            "AI polish access point module feature gate",
        )

    return update_method_once(
        text,
        ".method public final getModuleDef(Landroid/content/Context;)Lamyy;",
        update,
        "AI polish access point module",
    )


def patch_ai_writing_tools_module(text: str) -> str:
    """Register the event consumer without requiring the circular Jarvis helper."""

    def update(method: str) -> str:
        dependency = """    new-array v0, v4, [Ljava/lang/Class;

    .line 48
    .line 49
    const-class v1, Lwth;

    .line 50
    .line 51
    aput-object v1, v0, v3

    .line 52
    .line 53
    invoke-virtual {p1, v0}, Lamym;->g([Ljava/lang/Class;)V

    .line 54
    .line 55
    .line 56
"""
        gate = """    sget-object v0, Lwtu;->c:Lajoj;

    .line 57
    .line 58
    invoke-virtual {p1, v0}, Lamym;->k(Lajoj;)V

    .line 59
"""
        method = replace_once(
            method,
            dependency,
            "    .line 56\n",
            "AI writing tools unused Jarvis helper dependency",
        )
        return replace_once(
            method,
            gate,
            "    .line 59\n",
            "AI writing tools module feature gate",
        )

    return update_method_once(
        text,
        ".method public final getModuleDef(Landroid/content/Context;)Lamyy;",
        update,
        "AI writing tools module",
    )


def patch_ai_polish_definition(text: str) -> str:
    """Relabel the pinned native definition and keep its Runnable click route."""
    original_sha256 = "ed39bc2fdfc0ea9bd330cca02191b1cdf1193a3ab1a0977122840b1f7c64fdc2"
    replacement = """.method public final b(Ljava/lang/String;Z)Lagpb;
    .locals 3

    new-instance v0, Lwsa;
    invoke-direct {v0, p0}, Lwsa;-><init>(Lwse;)V

    xor-int/lit8 v1, p2, 0x1
    invoke-static {v1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;
    move-result-object v1

    const/4 v2, 0x0
    invoke-static {p1, v0, v2, v1}, Lwqw;->a(Ljava/lang/String;Lagpa;Lagox;Ljava/lang/Boolean;)Lagow;
    move-result-object p1

    const v0, 0x7f1406b9
    invoke-virtual {p1, v0}, Lagow;->l(I)V
    invoke-virtual {p1, v0}, Lagow;->j(I)V

    const v0, 0x7f0804cc
    invoke-virtual {p1, v0}, Lagow;->k(I)V

    new-instance v0, Lwsb;
    invoke-direct {v0, p0, p2}, Lwsb;-><init>(Lwse;Z)V
    invoke-virtual {p1, v0}, Lagow;->u(Ljava/lang/Runnable;)V

    move-object v0, p1
    check-cast v0, Lagpt;
    const-string v1, "AI 润色"
    iput-object v1, v0, Lagpt;->d:Ljava/lang/String;
    iput-object v1, v0, Lagpt;->e:Ljava/lang/String;

    invoke-virtual {p1}, Lagow;->b()Lagpb;
    move-result-object p0
    return-object p0
.end method"""
    return update_method_once(
        text,
        ".method public final b(Ljava/lang/String;Z)Lagpb;",
        lambda method: replace_verified_method(
            method,
            original_sha256,
            replacement,
            "AI polish access point definition",
        ),
        "AI polish access point definition",
    )


def patch_ai_polish_click(text: str) -> str:
    """Rewrite only the exact pinned Runnable, never a drifted implementation."""
    original_sha256 = "65e1f6709bf16beb028692670936377f16d3e5b5212e95b7ad2a70a0ba8b3d82"
    replacement = """.method public final run()V
    .locals 4

    iget-object p0, p0, Lwsb;->a:Lwse;

    sget-object v0, Lajkj;->d:Lajkj;
    sget-object v1, Lbajq;->m:Lbajq;
    invoke-static {v1}, Laodi;->d(Lbajq;)Laodi;
    move-result-object v1

    invoke-virtual {p0}, Lajki;->ae()Lajlf;
    move-result-object v2
    invoke-static {v2}, Lj$/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;
    new-instance v3, Lwdz;
    invoke-direct {v3, v2}, Lwdz;-><init>(Lajlf;)V

    sget-object v2, Lakhf;->g:Lakhf;
    const/4 p0, 0x0
    invoke-static {v0, v1, p0, v2, v3}, Lwtz;->f(Lajkj;Laodi;ZLakhf;Ljava/util/function/Consumer;)V
    return-void
.end method"""
    return update_method_once(
        text,
        ".method public final run()V",
        lambda method: replace_verified_method(
            method,
            original_sha256,
            replacement,
            "AI polish Runnable click",
        ),
        "AI polish Runnable click",
    )


def patch_power_key_polish_default(text: str) -> str:
    """Patch only the pinned power-key selector, then migrate the voice default."""
    original_sha256 = "135228d0c97f916472073887530e8338b7c73069e4fecefdda2a0eeff97c4427"
    replacement = """.method private static N(Landroid/content/Context;Lanyg;ZLaivh;)Ljava/lang/String;
    .locals 2

    const v0, 0x7f1404b3

    if-eqz p2, :vorflux_polish_without_persistence

    invoke-static {p3}, Lagxe;->M(Laivh;)I
    move-result p2

    invoke-virtual {p0, v0}, Landroid/content/Context;->getString(I)Ljava/lang/String;
    move-result-object p3

    invoke-virtual {p1, p2, p3}, Lanxc;->o(ILjava/lang/String;)Ljava/lang/String;
    move-result-object v0

    const-string v1, "voice"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result p0
    if-eqz p0, :vorflux_polish_selection_ready

    invoke-virtual {p1, p2, p3}, Lanxc;->t(ILjava/lang/String;)V
    move-object v0, p3

    :vorflux_polish_selection_ready
    return-object v0

    :vorflux_polish_without_persistence
    invoke-virtual {p0, v0}, Landroid/content/Context;->getString(I)Ljava/lang/String;
    move-result-object p0
    return-object p0
.end method"""
    return update_method_once(
        text,
        ".method private static N(Landroid/content/Context;Lanyg;ZLaivh;)Ljava/lang/String;",
        lambda method: replace_verified_method(
            method,
            original_sha256,
            replacement,
            "fixed power-key AI polish selection",
        ),
        "fixed power-key AI polish selection",
    )


def patch_non_customized_personalization(text: str) -> str:
    """Reject Jarvis before Lagww personalization and scrub its legacy set entry."""
    constructor_sha256 = "db65c5ebaa7996b3c942a2c58eda4d89a9fa498f9b7004717e48fec8eb494566"
    waiting_list_sha256 = "52af0affc0d443bd391f22186d958bcd3afaaeb77bd2176ad1e7d915c4196428"
    high_investment_sha256 = "4ac5e3a5b455353247127b92ecdd73339f11599c83976b6a7b8c857bd8b7c0c5"

    def patch_constructor(method: str) -> str:
        validate_method_sha256(
            method,
            constructor_sha256,
            "non-customized personalization state load",
        )
        method = replace_once(
            method,
            "    .locals 3",
            "    .locals 4",
            "non-customized personalization state locals",
        )
        load_tail = """    move-result-object p1

    .line 37
    if-eqz p1, :cond_0

    .line 38
    .line 39
    invoke-static {p1}, Lazha;->k(Ljava/util/Collection;)Lazha;

    .line 40
    .line 41
    .line 42
    move-result-object v0

    .line 43
    :cond_0
    iput-object v0, p0, Lagww;->n:Lazha;"""
        scrubbed_tail = """    move-result-object p1

    .line 37
    if-eqz p1, :cond_0

    new-instance v2, Ljava/util/HashSet;
    invoke-direct {v2, p1}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V
    const-string v3, "jarvis"
    invoke-interface {v2, v3}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z
    move-result p1
    if-eqz p1, :vorflux_remained_state_ready
    iget-object p1, p0, Lagww;->l:Lanyg;
    const v3, 0x7f140ac1
    invoke-virtual {p1, v3, v2}, Lanxc;->u(ILjava/util/Set;)V

    :vorflux_remained_state_ready
    invoke-static {v2}, Lazha;->k(Ljava/util/Collection;)Lazha;

    .line 40
    .line 41
    .line 42
    move-result-object v0

    .line 43
    :cond_0
    iput-object v0, p0, Lagww;->n:Lazha;"""
        return replace_once(
            method,
            load_tail,
            scrubbed_tail,
            "non-customized legacy jarvis state scrub",
        )

    text = update_method_once(
        text,
        ".method public constructor <init>(Landroid/content/Context;Lagsp;)V",
        patch_constructor,
        "non-customized personalization state load",
    )

    waiting_list_replacement = """.method public static q()Lazha;
    .locals 3

    sget-object v0, Lagpc;->l:Lajoj;
    invoke-interface {v0}, Lajoj;->g()Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;

    const-string v1, ";"
    invoke-virtual {v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;
    move-result-object v0

    new-instance v1, Ljava/util/ArrayList;
    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V
    invoke-static {v1, v0}, Ljava/util/Collections;->addAll(Ljava/util/Collection;[Ljava/lang/Object;)Z
    const-string v2, "jarvis"
    :vorflux_remove_jarvis_waiting_list
    invoke-interface {v1, v2}, Ljava/util/List;->remove(Ljava/lang/Object;)Z
    move-result v0
    if-nez v0, :vorflux_remove_jarvis_waiting_list
    invoke-static {v1}, Lazha;->k(Ljava/util/Collection;)Lazha;
    move-result-object v0
    return-object v0
.end method"""
    text = update_method_once(
        text,
        ".method public static q()Lazha;",
        lambda method: replace_verified_method(
            method,
            waiting_list_sha256,
            waiting_list_replacement,
            "non-customized personalization waiting list",
        ),
        "non-customized personalization waiting list",
    )

    high_investment_replacement = """.method private final w()Ljava/lang/String;
    .locals 2

    sget-object v0, Lagpc;->t:Lajoj;
    invoke-interface {v0}, Lajoj;->g()Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;

    const-string v1, "jarvis"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :vorflux_no_high_investment_feature

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z
    move-result v1
    if-nez v1, :vorflux_no_high_investment_feature

    iget-object p0, p0, Lagww;->o:Lagsp;
    invoke-virtual {p0, v0}, Lagsp;->d(Ljava/lang/String;)Z
    move-result p0
    if-eqz p0, :vorflux_no_high_investment_feature
    return-object v0

    :vorflux_no_high_investment_feature
    const/4 p0, 0x0
    return-object p0
.end method"""
    return update_method_once(
        text,
        ".method private final w()Ljava/lang/String;",
        lambda method: replace_verified_method(
            method,
            high_investment_sha256,
            high_investment_replacement,
            "non-customized high investment feature",
        ),
        "non-customized high investment feature",
    )


def patch_customized_personalization(text: str) -> str:
    """Reject Jarvis before Lagwo promotion and scrub only Jarvis legacy state."""
    original_sha256 = "3fb09ee53d6994b6a0bce65875b24d1cf07c06ec8303cf36ba7797d7b1d220c9"

    def update(method: str) -> str:
        validate_method_sha256(
            method,
            original_sha256,
            "customized high investment personalization",
        )
        method = replace_once(
            method,
            "    .locals 10",
            "    .locals 11",
            "customized high investment personalization locals",
        )
        prologue = """    .line 2
    iput v0, p0, Lagsl;->h:I

    iget-object v4, p0, Lagwo;->m:Lanyg;
    const v5, 0x7f140abf
    invoke-virtual {v4, v5}, Lanyg;->V(I)Ljava/util/Set;
    move-result-object v6
    new-instance v7, Ljava/util/HashSet;
    invoke-direct {v7, v6}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V
    invoke-interface {v7}, Ljava/util/Set;->iterator()Ljava/util/Iterator;
    move-result-object v8

    :vorflux_jarvis_state_loop
    invoke-interface {v8}, Ljava/util/Iterator;->hasNext()Z
    move-result v9
    if-eqz v9, :vorflux_jarvis_state_ready
    invoke-interface {v8}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v9
    check-cast v9, Ljava/lang/String;
    const-string v10, "jarvis:"
    invoke-virtual {v9, v10}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v9
    if-eqz v9, :vorflux_jarvis_state_loop
    invoke-interface {v8}, Ljava/util/Iterator;->remove()V
    goto :vorflux_jarvis_state_loop

    :vorflux_jarvis_state_ready
    invoke-interface {v7, v6}, Ljava/util/Set;->equals(Ljava/lang/Object;)Z
    move-result v6
    if-nez v6, :vorflux_jarvis_state_scrubbed
    invoke-virtual {v4, v5, v7}, Lanxc;->u(ILjava/util/Set;)V

    :vorflux_jarvis_state_scrubbed"""
        method = replace_once(
            method,
            """    .line 2
    iput v0, p0, Lagsl;->h:I""",
            prologue,
            "customized legacy jarvis promotion state scrub",
        )
        jarvis_check = """    move-result-object v4

    .line 33
    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    .line 34
    .line 35
    .line 36
    move-result v4

    .line 37
    const-string v5, \"CustomizedOrderPersonalizeTopBarHandler.java\""""
        rejection = """    move-result-object v4

    .line 33
    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    .line 34
    .line 35
    .line 36
    move-result v4
    if-eqz v4, :vorflux_non_jarvis_feature

    const/4 v4, 0x0
    iput-object v4, p0, Lagwo;->j:Lagwm;
    iput-object v4, p0, Lagwo;->o:Lagwn;
    const/4 v4, 0x0
    iput-boolean v4, p0, Lagwo;->p:Z
    invoke-direct {p0}, Lagwo;->s()V

    return-void

    :vorflux_non_jarvis_feature

    .line 37
    const-string v5, \"CustomizedOrderPersonalizeTopBarHandler.java\""""
        return replace_once(
            method,
            jarvis_check,
            rejection,
            "customized jarvis rejection before Lagwn",
        )

    return update_method_once(
        text,
        ".method public final q()V",
        update,
        "customized high investment personalization",
    )


def patch_customized_order_persistence(text: str) -> str:
    """Migrate completed Jarvis promotions in both persisted order variants."""
    original_sha256 = "4ef5004e66a0330605407e8c2fc49fbc7b0dad7cc07034ac5595ced22bbb35b0"

    def update(method: str) -> str:
        validate_method_sha256(
            method,
            original_sha256,
            "customized persisted order load",
        )
        load_preferences = """    invoke-static {v0}, Lanyg;->N(Landroid/content/Context;)Lanyg;

    .line 222
    .line 223
    .line 224
    move-result-object v4

    .line 225
    sget-object v6, Laivh;->f:Laivh;"""
        migrate_preferences = """    invoke-static {v0}, Lanyg;->N(Landroid/content/Context;)Lanyg;

    .line 222
    .line 223
    .line 224
    move-result-object v4

    const v5, 0x7f140935
    const v8, 0x7f140934
    invoke-static {v4, v5, v8}, Lagrz;->o(Lanyg;II)V
    const v11, 0x7f1409c7
    const v8, 0x7f1409c6
    invoke-static {v4, v11, v8}, Lagrz;->o(Lanyg;II)V

    .line 225
    sget-object v6, Laivh;->f:Laivh;"""
        return replace_once(
            method,
            load_preferences,
            migrate_preferences,
            "customized persisted order migration calls",
        )

    text = update_method_once(
        text,
        ".method static n(Landroid/content/Context;Lagut;Laivh;Lazha;Lazha;Z)Lagrz;",
        update,
        "customized persisted order load",
    )
    helper = """
.method private static o(Lanyg;II)V
    .locals 10

    invoke-virtual {p0, p1}, Lanyg;->ar(I)Z
    move-result v0
    if-eqz v0, :vorflux_customized_order_done

    invoke-virtual {p0, p1}, Lanyg;->S(I)Ljava/lang/String;
    move-result-object v0
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z
    move-result v1
    if-nez v1, :vorflux_customized_order_done

    const-string v1, ";"
    invoke-virtual {v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;
    move-result-object v0

    new-instance v2, Ljava/util/ArrayList;
    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V
    const/4 v3, 0x0
    const/4 v4, 0x0
    const/4 v5, 0x0
    const/4 v6, -0x1
    invoke-virtual {p0, p2, v6}, Lanxc;->l(II)I
    move-result v6
    array-length v7, v0

    :vorflux_customized_order_loop
    if-ge v3, v7, :vorflux_customized_order_scanned
    aget-object v8, v0, v3
    const-string v9, "jarvis"
    invoke-virtual {v9, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v9
    if-eqz v9, :vorflux_customized_order_keep

    const/4 v5, 0x1
    if-ltz v6, :vorflux_customized_order_next
    if-ge v3, v6, :vorflux_customized_order_next
    add-int/lit8 v4, v4, 0x1
    goto :vorflux_customized_order_next

    :vorflux_customized_order_keep
    invoke-interface {v2, v8}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :vorflux_customized_order_next
    add-int/lit8 v3, v3, 0x1
    goto :vorflux_customized_order_loop

    :vorflux_customized_order_scanned
    if-eqz v5, :vorflux_customized_order_done
    const-string v0, ";"
    invoke-static {v0, v2}, Landroid/text/TextUtils;->join(Ljava/lang/CharSequence;Ljava/lang/Iterable;)Ljava/lang/String;
    move-result-object v0
    invoke-virtual {p0, p1, v0}, Lanxc;->t(ILjava/lang/String;)V

    if-lez v4, :vorflux_customized_order_done
    sub-int/2addr v6, v4
    if-gez v6, :vorflux_customized_count_ready
    const/4 v6, 0x0

    :vorflux_customized_count_ready
    invoke-virtual {p0, p2, v6}, Lanxc;->r(II)V

    :vorflux_customized_order_done
    return-void
.end method
"""
    return replace_once(
        text,
        "\n\n# virtual methods\n",
        helper + "\n# virtual methods\n",
        "customized persisted order migration helper",
    )


def patch_voice_reserve_entry(text: str) -> str:
    """Keep the native voice definition, but stop claiming the fixed holder."""

    def update(method: str) -> str:
        default_metadata = """    const/4 v1, 0x1

    .line 36
    invoke-static {v1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    .line 37
    .line 38
    .line 39
    move-result-object v1

    .line 40
    const-string v2, "default"

    .line 41
    .line 42
    invoke-virtual {v0, v2, v1}, Lagow;->e(Ljava/lang/String;Ljava/lang/Object;)V

    .line 43
    .line 44
    .line 45
"""
        return replace_once(
            method,
            default_metadata,
            "    .line 45\n",
            "native voice fixed-holder default metadata",
        )

    return update_method_once(
        text,
        ".method private final d(Z)Lagow;",
        update,
        "native voice reserve access point",
    )


def patch_ai_polish_entry(root: Path) -> tuple[tuple[Path, str], ...]:
    provider_path = root / "smali/wsf.smali"
    module_path = root / "smali/wej.smali"
    state_path = root / "smali_classes2/wok.smali"
    definition_path = root / "smali/wse.smali"
    click_path = root / "smali_classes2/wsb.smali"
    holder_path = root / "smali/agxe.smali"
    customized_order_persistence_path = root / "smali/agrz.smali"
    non_customized_personalization_path = root / "smali_classes3/agww.smali"
    customized_personalization_path = root / "smali_classes3/agwo.smali"
    voice_path = root / "smali/shb.smali"

    return (
        (provider_path, patch_polish_provider_module(load(provider_path))),
        (module_path, patch_ai_writing_tools_module(load(module_path))),
        (state_path, patch_polish_state_eligibility(load(state_path))),
        (definition_path, patch_ai_polish_definition(load(definition_path))),
        (click_path, patch_ai_polish_click(load(click_path))),
        (holder_path, patch_power_key_polish_default(load(holder_path))),
        (
            customized_order_persistence_path,
            patch_customized_order_persistence(
                load(customized_order_persistence_path)
            ),
        ),
        (
            non_customized_personalization_path,
            patch_non_customized_personalization(
                load(non_customized_personalization_path)
            ),
        ),
        (
            customized_personalization_path,
            patch_customized_personalization(load(customized_personalization_path)),
        ),
        (voice_path, patch_voice_reserve_entry(load(voice_path))),
    )


def patch_translation_progress(root: Path, ui: str) -> tuple[Path, str, Path, str, Path, str]:
    ui_path = root / "smali/aciv.smali"
    request = """    invoke-interface {v0, v7, v1}, Lacgc;->d(Lacie;Lacgb;)V
"""
    request_with_progress = """    invoke-virtual {p0}, Laciv;->c()Lcom/google/android/apps/inputmethod/libs/translate/TranslateKeyboard;
    move-result-object v2
    if-eqz v2, :vorflux_progress_started
    const/4 v5, 0x1
    invoke-virtual {v2, v5}, Lcom/google/android/apps/inputmethod/libs/translate/TranslateKeyboard;->a(I)V
    :vorflux_progress_started
    invoke-interface {v0, v7, v1}, Lacgc;->d(Lacie;Lacgb;)V
"""
    ui = replace_once(ui, request, request_with_progress, "translation native progress start")

    input_cancel = """    invoke-virtual {p0}, Laciv;->af()V

    .line 16
"""
    input_cancel_with_cleanup = """    iget-object v0, p0, Laciv;->p:Lacgc;
    if-eqz v0, :vorflux_input_cancelled
    invoke-interface {v0}, Lacgc;->c()V
    :vorflux_input_cancelled
    invoke-virtual {p0}, Laciv;->c()Lcom/google/android/apps/inputmethod/libs/translate/TranslateKeyboard;
    move-result-object v0
    if-eqz v0, :vorflux_input_progress_cleared
    const/4 v1, 0x2
    invoke-virtual {v0, v1}, Lcom/google/android/apps/inputmethod/libs/translate/TranslateKeyboard;->a(I)V
    :vorflux_input_progress_cleared
    invoke-virtual {p0}, Laciv;->af()V

    .line 16
"""
    ui = replace_once(ui, input_cancel, input_cancel_with_cleanup, "translation input cancellation cleanup")

    ui = replace_once(
        ui,
        """    invoke-interface {v0}, Lacgc;->c()V

    .line 97
""",
        """    invoke-interface {v0}, Lacgc;->c()V
    invoke-virtual {p0}, Laciv;->c()Lcom/google/android/apps/inputmethod/libs/translate/TranslateKeyboard;
    move-result-object v0
    if-eqz v0, :vorflux_stop_progress_cleared
    const/4 v2, 0x2
    invoke-virtual {v0, v2}, Lcom/google/android/apps/inputmethod/libs/translate/TranslateKeyboard;->a(I)V
    :vorflux_stop_progress_cleared

    .line 97
""",
        "translation stop progress cleanup",
    )

    callback_path = root / "smali_classes2/acih.smali"
    callback = load(callback_path)
    callback = replace_once(
        callback,
        """    iget v0, p1, Lacif;->a:I
""",
        """    iget-object v0, p0, Lacih;->a:Laciv;
    invoke-virtual {v0}, Laciv;->c()Lcom/google/android/apps/inputmethod/libs/translate/TranslateKeyboard;
    move-result-object v0
    if-eqz v0, :vorflux_progress_cleared
    const/4 v1, 0x2
    invoke-virtual {v0, v1}, Lcom/google/android/apps/inputmethod/libs/translate/TranslateKeyboard;->a(I)V
    :vorflux_progress_cleared
    iget v0, p1, Lacif;->a:I
""",
        "translation terminal progress cleanup",
    )

    keyboard_path = root / "smali_classes2/com/google/android/apps/inputmethod/libs/translate/TranslateKeyboard.smali"
    keyboard = load(keyboard_path)
    keyboard = replace_once(
        keyboard,
        """    const p1, 0x7f141219

    .line 46
""",
        """    const p1, 0x7f140d8c

    .line 46
""",
        "native translating accessibility status",
    )
    return ui_path, ui, callback_path, callback, keyboard_path, keyboard


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit(f"Usage: {Path(sys.argv[0]).name} DECODED_APK_DIR")

    root = Path(sys.argv[1])
    if not root.is_dir():
        raise SystemExit(f"Decoded APK directory not found: {root}")

    provider = patch_translation_provider(root)
    progress = patch_translation_progress(root, provider[1])
    polish_entry = patch_ai_polish_entry(root)
    patches = (
        patch_development_certificate(root),
        patch_ai_polish_flow(root),
        patch_translation_settings(root),
        patch_always_reachable_ai_settings(root),
        *polish_entry,
        (progress[0], progress[1]),
        (progress[2], progress[3]),
        (progress[4], progress[5]),
    )
    for path, patched in patches:
        path.write_text(patched, encoding="utf-8")


if __name__ == "__main__":
    main()
