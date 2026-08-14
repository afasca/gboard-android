#!/usr/bin/env python3
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path
import tempfile

ROOT = Path(__file__).resolve().parents[1]
PATCHER_PATH = ROOT / "scripts/apply-smali-patches.py"
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


def test_toolbar_fallback_normalizes_both_branches():
    simple = """    move-result-object v0
    check-cast v0, Ljava/lang/String;
    return-object v0
"""
    fallback_body = """    if-eqz p1, :cond_0
    const-string p1, "sticker;settings;translate;"
    goto :goto_0
    :cond_0
    move-result-object p1
    check-cast p1, Ljava/lang/String;
    :goto_0
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z
    move-result v0
    invoke-static {p1, p0}, Lagsr;->e(Ljava/lang/String;Lazha;)Lazfk;
    move-result-object p0
    return-object p0
"""
    source = (
        ".method public static q(Lazha;)Lazfk;\n" + simple + ".end method\n\n"
        ".method private static t(Lazha;)Lazfk;\n" + simple + ".end method\n\n"
        ".method private static u(Lazha;)Lazfk;\n" + simple + ".end method\n\n"
        ".method private static v(Lazha;Z)Lazfk;\n" + fallback_body + ".end method\n\n"
        "# virtual methods\n"
    )
    with tempfile.TemporaryDirectory() as directory:
        root = Path(directory)
        (root / "smali").mkdir()
        (root / "smali/agsr.smali").write_text(source)
        _, patched = patcher.patch_toolbar_jarvis_persistence(root)

    fallback = method(patched, ".method private static v(Lazha;Z)Lazfk;")
    assert fallback.count("Lagsr;->z(Ljava/lang/String;)Ljava/lang/String;") == 1
    join = fallback.index("    :goto_0\n")
    normalize = fallback.index("Lagsr;->z(Ljava/lang/String;)Ljava/lang/String;")
    empty_check = fallback.index("Landroid/text/TextUtils;->isEmpty")
    parse = fallback.index("Lagsr;->e(Ljava/lang/String;Lazha;)Lazfk;")
    assert join < normalize < empty_check < parse
    assert fallback.rindex("check-cast p1, Ljava/lang/String;", 0, join) < join
    for signature in (
        ".method public static q(Lazha;)Lazfk;",
        ".method private static t(Lazha;)Lazfk;",
        ".method private static u(Lazha;)Lazfk;",
    ):
        assert method(patched, signature).count("Lagsr;->z(Ljava/lang/String;)Ljava/lang/String;") == 1


if __name__ == "__main__":
    test_polish_state_keeps_native_eligibility()
    test_toolbar_fallback_normalizes_both_branches()
    print("smali patch regression tests passed")
