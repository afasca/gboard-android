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

    invoke-virtual {p0}, Lbi;->x()Landroid/content/Context;
    move-result-object v0
    new-instance v1, Landroidx/preference/Preference;
    invoke-direct {v1, v0}, Landroidx/preference/Preference;-><init>(Landroid/content/Context;)V
    const-string v2, "Gboard AI · OpenAI 兼容设置"
    invoke-virtual {v1, v2}, Landroidx/preference/Preference;->V(Ljava/lang/CharSequence;)V
    const-string v2, "配置 API 地址和密钥；模型自动获取"
    invoke-virtual {v1, v2}, Landroidx/preference/Preference;->n(Ljava/lang/CharSequence;)V
    const-string v2, "gboard_ai_settings"
    invoke-virtual {v1, v2}, Landroidx/preference/Preference;->P(Ljava/lang/String;)V
    new-instance v2, Lcom/vorflux/gboardai/AiSettingsClick;
    invoke-direct {v2, v0}, Lcom/vorflux/gboardai/AiSettingsClick;-><init>(Landroid/content/Context;)V
    iput-object v2, v1, Landroidx/preference/Preference;->o:Leaf;
    invoke-virtual {p0}, Leaq;->n()Landroidx/preference/PreferenceScreen;
    move-result-object v0
    invoke-virtual {v0, v1}, Landroidx/preference/PreferenceGroup;->an(Landroidx/preference/Preference;)V

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


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit(f"Usage: {Path(sys.argv[0]).name} DECODED_APK_DIR")

    root = Path(sys.argv[1])
    if not root.is_dir():
        raise SystemExit(f"Decoded APK directory not found: {root}")

    patches = (
        patch_development_certificate(root),
        patch_translation_provider(root),
        patch_ai_polish_flow(root),
        patch_translation_settings(root),
        patch_writing_tools_toolbar_flag(root),
    )
    for path, patched in patches:
        path.write_text(patched, encoding="utf-8")


if __name__ == "__main__":
    main()
