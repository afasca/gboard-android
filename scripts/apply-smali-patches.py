#!/usr/bin/env python3
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


def patch_writing_tools_toolbar_flag(root: Path) -> tuple[Path, str]:
    path = root / "smali/amaj.smali"
    text = load(path)
    needle = """    const-string v0, "enable_writing_tools_v2_on_toolbar"

    .line 133
    .line 134
    invoke-static {v0, v1}, Lajom;->a(Ljava/lang/String;Z)Lajoj;
"""
    replacement = """    const-string v0, "enable_writing_tools_v2_on_toolbar"

    .line 133
    .line 134
    const/4 v2, 0x1
    invoke-static {v0, v2}, Lajom;->a(Ljava/lang/String;Z)Lajoj;
"""
    return path, replace_once(
        text,
        needle,
        replacement,
        "writing tools toolbar flag",
    )


def patch_polish_state_eligibility(text: str) -> str:
    """Bypass the module gate only for the polish toolbar provider.

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


def _patch_provider_registration_gate(
    text: str,
    needle: str,
    replacement: str,
    diagnostic: str,
) -> str:
    return update_method_once(
        text,
        ".method public final getModuleDef(Landroid/content/Context;)Lamyy;",
        lambda method: replace_once(
            method,
            needle,
            replacement,
            diagnostic,
        ),
        diagnostic,
    )


def patch_jarvis_provider_registration(text: str) -> str:
    """Register the Jarvis access-point provider without globally enabling it."""
    needle = """    sget-object p1, Lwtu;->a:Lajoj;

    .line 57
    .line 58
    invoke-virtual {p0, p1}, Lamym;->k(Lajoj;)V

    .line 59
"""
    replacement = """    .line 59
"""
    diagnostic = "AI polish Jarvis provider registration gate"
    return _patch_provider_registration_gate(
        text,
        needle,
        replacement,
        diagnostic,
    )


def patch_minors_checker_provider_registration(text: str) -> str:
    """Initialize the existing minors-readiness producer without the global gate."""
    needle = """    sget-object p1, Lwtu;->a:Lajoj;

    .line 20
    .line 21
    invoke-virtual {p0, p1}, Lamym;->k(Lajoj;)V

    .line 22
"""
    replacement = """    .line 22
"""
    diagnostic = "AI polish minors-checker provider registration gate"
    return _patch_provider_registration_gate(
        text,
        needle,
        replacement,
        diagnostic,
    )


def patch_ai_polish_entry(root: Path) -> tuple[tuple[Path, str], ...]:
    order_path = root / "smali/agpc.smali"
    order = replace_once(
        load(order_path),
        'const-string v1, "search;sticker;gif_search;clipboard;settings;theme_setting;one_handed;textediting;share;translate;floating_keyboard"',
        'const-string v1, "jarvis;search;sticker;gif_search;clipboard;settings;theme_setting;one_handed;textediting;share;translate;floating_keyboard"',
        "AI polish access point default order",
    )

    registration_path = root / "smali/wqp.smali"
    registration = patch_jarvis_provider_registration(load(registration_path))

    minors_provider_path = root / "smali/wgw.smali"
    minors_provider = patch_minors_checker_provider_registration(
        load(minors_provider_path)
    )

    provider_path = root / "smali/wsf.smali"
    provider = replace_once(
        load(provider_path),
        """    sget-object p1, Lwtu;->r:Lajoj;

    .line 31
    .line 32
    invoke-virtual {p0, p1}, Lamym;->k(Lajoj;)V

    .line 33
""",
        """    .line 33
""",
        "AI polish access point module feature gate",
    )

    module_path = root / "smali/wej.smali"
    module = replace_once(
        load(module_path),
        """    sget-object v0, Lwtu;->c:Lajoj;

    .line 57
    .line 58
    invoke-virtual {p1, v0}, Lamym;->k(Lajoj;)V

    .line 59
""",
        """    .line 59
""",
        "AI writing tools module feature gate",
    )

    state_path = root / "smali_classes2/wok.smali"
    state = patch_polish_state_eligibility(load(state_path))

    label_path = root / "smali/wse.smali"
    label = load(label_path)
    method_start = label.index(".method public final b(Ljava/lang/String;Z)Lagpb;")
    method_end = label.index(".end method", method_start) + len(".end method")
    label_method = """.method public final b(Ljava/lang/String;Z)Lagpb;
    .locals 4
    new-instance v0, Lwsa;
    invoke-direct {v0, p0}, Lwsa;-><init>(Lwse;)V
    xor-int/lit8 v1, p2, 0x1
    invoke-static {v1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;
    move-result-object v1
    const/4 v2, 0x0
    invoke-static {p1, v0, v2, v1}, Lwqw;->a(Ljava/lang/String;Lagpa;Lagox;Ljava/lang/Boolean;)Lagow;
    move-result-object p1
    const/4 v0, 0x0
    invoke-virtual {p1, v0}, Lagow;->l(I)V
    invoke-virtual {p1, v0}, Lagow;->j(I)V
    const v0, 0x7f0804cc
    invoke-virtual {p1, v0}, Lagow;->k(I)V
    new-instance v0, Lwsb;
    invoke-direct {v0, p0, p2}, Lwsb;-><init>(Lwse;Z)V
    invoke-virtual {p1, v0}, Lagow;->u(Ljava/lang/Runnable;)V
    move-object v0, p1
    check-cast v0, Lagpt;
    const-string v3, "AI 润色"
    iput-object v3, v0, Lagpt;->d:Ljava/lang/String;
    iput-object v3, v0, Lagpt;->e:Ljava/lang/String;
    invoke-virtual {p1}, Lagow;->b()Lagpb;
    move-result-object p0
    return-object p0
.end method"""
    label = label[:method_start] + label_method + label[method_end:]

    click_path = root / "smali_classes2/wsa.smali"
    click = load(click_path)
    click_start = click.index(".method public final a(Lagpe;Landroid/view/View;)V")
    click_end = click.index(".end method", click_start) + len(".end method")
    click_method = """.method public final a(Lagpe;Landroid/view/View;)V
    .locals 4
    iget-object p0, p0, Lwsa;->a:Lwse;
    iget-object p1, p0, Lwse;->b:Lamua;
    iget-object p2, p0, Lwse;->c:Lj$/time/Instant;
    invoke-static {p1, p2}, Lwqw;->e(Lamua;Lj$/time/Instant;)V
    invoke-static {}, Lj$/time/Instant;->now()Lj$/time/Instant;
    move-result-object p1
    iput-object p1, p0, Lwse;->c:Lj$/time/Instant;
    sget-object v0, Lajkj;->d:Lajkj;
    sget-object v1, Lbajq;->m:Lbajq;
    invoke-static {v1}, Laodi;->d(Lbajq;)Laodi;
    move-result-object v1
    invoke-virtual {p0}, Lajki;->ae()Lajlf;
    move-result-object v2
    new-instance v3, Lwdz;
    invoke-direct {v3, v2}, Lwdz;-><init>(Lajlf;)V
    sget-object v2, Lakhf;->g:Lakhf;
    const/4 p0, 0x0
    invoke-static {v0, v1, p0, v2, v3}, Lwtz;->f(Lajkj;Laodi;ZLakhf;Ljava/util/function/Consumer;)V
    return-void
.end method"""
    click = click[:click_start] + click_method + click[click_end:]

    return (
        (order_path, order),
        (registration_path, registration),
        (minors_provider_path, minors_provider),
        (provider_path, provider),
        (module_path, module),
        (state_path, state),
        (label_path, label),
        (click_path, click),
    )


def patch_toolbar_jarvis_persistence(root: Path) -> tuple[Path, str]:
    """Ensure jarvis survives every toolbar-order source, including upgrades."""
    path = root / "smali/agsr.smali"
    text = load(path)

    def inject(method: str, register: str, label: str) -> str:
        needle = f"    check-cast {register}, Ljava/lang/String;\n"
        replacement = needle + f"    invoke-static {{{register}}}, Lagsr;->z(Ljava/lang/String;)Ljava/lang/String;\n    move-result-object {register}\n"
        return replace_once(method, needle, replacement, label)

    for signature, register, label in (
        (".method public static q(Lazha;)Lazfk;", "v0", "server toolbar order"),
        (".method private static t(Lazha;)Lazfk;", "v0", "persisted toolbar order"),
        (".method private static u(Lazha;)Lazfk;", "v0", "experiment toolbar order"),
    ):
        text = update_method_once(
            text,
            signature,
            lambda method, r=register, l=label: inject(method, r, l),
            label,
        )

    def inject_fallback_join(method: str) -> str:
        needle = """    :goto_0
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z
"""
        replacement = """    :goto_0
    invoke-static {p1}, Lagsr;->z(Ljava/lang/String;)Ljava/lang/String;
    move-result-object p1

    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z
"""
        return replace_once(
            method,
            needle,
            replacement,
            "fallback toolbar order join",
        )

    text = update_method_once(
        text,
        ".method private static v(Lazha;Z)Lazfk;",
        inject_fallback_join,
        "fallback toolbar order",
    )

    helper = r'''
.method private static z(Ljava/lang/String;)Ljava/lang/String;
    .locals 3

    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z
    move-result v0
    if-eqz v0, :vorflux_jarvis_nonempty
    const-string p0, "jarvis"
    return-object p0

    :vorflux_jarvis_nonempty
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, ";"
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    const-string v2, ";jarvis;"
    invoke-virtual {v0, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z
    move-result v0
    if-eqz v0, :vorflux_jarvis_missing
    return-object p0

    :vorflux_jarvis_missing
    const-string v0, "jarvis;"
    invoke-virtual {v0, p0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;
    move-result-object p0
    return-object p0
.end method
'''
    text = replace_once(
        text,
        "\n# virtual methods\n",
        helper + "\n# virtual methods\n",
        "toolbar jarvis normalization helper",
    )
    return path, text

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
        patch_writing_tools_toolbar_flag(root),
        patch_toolbar_jarvis_persistence(root),
        *polish_entry,
        (progress[0], progress[1]),
        (progress[2], progress[3]),
        (progress[4], progress[5]),
    )
    for path, patched in patches:
        path.write_text(patched, encoding="utf-8")


if __name__ == "__main__":
    main()
