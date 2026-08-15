#!/usr/bin/env python3
"""Decode a signed APK and enforce the fixed-holder AI polish release contract."""

import argparse
import hashlib
from pathlib import Path
import re
import shutil
import subprocess
import tempfile


def method(text: str, signature: str) -> str:
    count = text.count(signature)
    if count != 1:
        raise SystemExit(f"{signature}: expected exactly one method, found {count}")
    start = text.index(signature)
    end = text.find("\n.end method", start)
    if end == -1:
        raise SystemExit(f"{signature}: method end not found")
    return text[start : end + len("\n.end method")]


def read(root: Path, relative: str) -> str:
    path = root / relative
    if not path.is_file():
        raise SystemExit(f"missing decoded contract file: {relative}")
    return path.read_text(encoding="utf-8")


def require(value: bool, message: str) -> None:
    if not value:
        raise SystemExit(message)


def require_locals(method_text: str, minimum: int, label: str) -> None:
    declaration = re.search(r"^    \.locals (\d+)$", method_text, re.MULTILINE)
    require(declaration is not None, f"{label}: missing .locals declaration")
    require(int(declaration.group(1)) >= minimum, f"{label}: insufficient local registers")


def require_returns(
    method_text: str,
    expected: tuple[str, ...],
    label: str,
) -> None:
    returns = tuple(
        line.strip()
        for line in method_text.splitlines()
        if line.strip().startswith("return")
    )
    require(returns == expected, f"{label}: return/register mismatch")


def normalized_method_sha256(method_text: str) -> str:
    normalized = "\n".join(
        line.rstrip()
        for line in method_text.splitlines()
        if line.strip() and not line.lstrip().startswith((".line ", ".local "))
    )
    return hashlib.sha256(normalized.encode("utf-8")).hexdigest()


def require_method_sha256(
    method_text: str,
    expected: str | tuple[str, ...],
    label: str,
) -> None:
    actual = normalized_method_sha256(method_text)
    allowed = (expected,) if isinstance(expected, str) else expected
    require(actual in allowed, f"{label}: patched method SHA-256 mismatch")


def verify(decoded: Path) -> None:
    lifecycle = method(
        read(decoded, "smali_classes2/wsa.smali"),
        ".method public final a(Lagpe;Landroid/view/View;)V",
    )
    require("const/16 v1, -0x27f9" in lifecycle, "missing native lifecycle event")
    require("Lwtz;->f(" not in lifecycle, "polish dispatch leaked into lifecycle callback")
    require("Lakhf;->g:Lakhf;" not in lifecycle, "proofread action leaked into lifecycle callback")

    definition = method(
        read(decoded, "smali/wse.smali"),
        ".method public final b(Ljava/lang/String;Z)Lagpb;",
    )
    for contract in (
        "const v0, 0x7f0804cc",
        "const v0, 0x7f1406b9",
        "new-instance v0, Lwsa;",
        "new-instance v0, Lwsb;",
        "Lagow;->u(Ljava/lang/Runnable;)V",
    ):
        require(contract in definition, f"missing polish definition contract: {contract}")
    require(
        'const-string v1, "AI 润色"' in definition
        or 'const-string v1, "AI \\u6da6\\u8272"' in definition,
        "missing AI polish raw label",
    )

    click = method(
        read(decoded, "smali_classes2/wsb.smali"),
        ".method public final run()V",
    )
    for contract in (
        "invoke-virtual {p0}, Lajki;->ae()Lajlf;",
        "Lj$/util/Objects;->requireNonNull(Ljava/lang/Object;)Ljava/lang/Object;",
        "new-instance v3, Lwdz;",
        "sget-object v2, Lakhf;->g:Lakhf;",
        "Lwtz;->f(Lajkj;Laodi;ZLakhf;Ljava/util/function/Consumer;)V",
    ):
        require(contract in click, f"missing polish click contract: {contract}")

    holder = method(
        read(decoded, "smali/agxe.smali"),
        ".method private static N(Landroid/content/Context;Lanyg;ZLaivh;)Ljava/lang/String;",
    )
    for contract in (
        "const v0, 0x7f1404b3",
        'const-string v1, "voice"',
        "Lanxc;->o(ILjava/lang/String;)Ljava/lang/String;",
        "Lanxc;->t(ILjava/lang/String;)V",
    ):
        require(contract in holder, f"missing fixed-holder contract: {contract}")

    voice_file = read(decoded, "smali/shb.smali")
    voice_builder = method(voice_file, ".method private final d(Z)Lagow;")
    require('const-string v2, "default"' not in voice_builder, "voice still claims fixed holder")
    for contract in (
        "Latbs;->g(Lagow;)V",
        "Lsgw;-><init>(Lshb;Z)V",
        "Lsgx;-><init>(Lshb;Z)V",
    ):
        require(contract in voice_builder, f"missing native voice builder contract: {contract}")
    voice_action = method(voice_file, ".method public final b(I)V")
    for contract in (
        "const/16 v6, -0x273a",
        "const/16 v6, -0x275b",
        "Latbs;->f(Lagow;Z)V",
    ):
        require(contract in voice_action, f"missing native voice action contract: {contract}")

    provider_token = method(
        read(decoded, "smali/wtv.smali"),
        ".method static constructor <clinit>()V",
    )
    require(provider_token.count('const-string v0, "jarvis"') == 1, "jarvis provider token is not singular")

    non_customized = read(decoded, "smali_classes3/agww.smali")
    remained_load = method(
        non_customized,
        ".method public constructor <init>(Landroid/content/Context;Lagsp;)V",
    )
    waiting_list = method(non_customized, ".method public static q()Lazha;")
    high_investment = method(
        non_customized,
        ".method private final w()Ljava/lang/String;",
    )
    require_locals(remained_load, 4, "non-customized state scrub")
    for contract in (
        'const-string v3, "jarvis"',
        "Ljava/util/Set;->remove(Ljava/lang/Object;)Z",
        "const v3, 0x7f140ac1",
        "Lanxc;->u(ILjava/util/Set;)V",
    ):
        require(contract in remained_load, f"missing non-customized state scrub: {contract}")
    for contract in (
        'const-string v2, "jarvis"',
        "Ljava/util/List;->remove(Ljava/lang/Object;)Z",
        "Lazha;->k(Ljava/util/Collection;)Lazha;",
    ):
        require(contract in waiting_list, f"missing waiting-list rejection: {contract}")
    require(
        waiting_list.index('const-string v2, "jarvis"')
        < waiting_list.index("Lazha;->k(Ljava/util/Collection;)Lazha;"),
        "jarvis waiting-list rejection occurs after immutable construction",
    )
    require(
        waiting_list.count("Ljava/util/List;->remove(Ljava/lang/Object;)Z") == 1
        and "if-nez v0" in waiting_list,
        "waiting-list rejection does not remove all exact Jarvis entries",
    )
    require_returns(
        waiting_list,
        ("return-object v0",),
        "non-customized waiting-list filter",
    )
    for contract in (
        'const-string v1, "jarvis"',
        "Ljava/lang/String;->equals(Ljava/lang/Object;)Z",
        "Lagsp;->d(Ljava/lang/String;)Z",
        "return-object p0",
    ):
        require(contract in high_investment, f"missing high-investment rejection: {contract}")
    require(
        high_investment.index('const-string v1, "jarvis"')
        < high_investment.index("Lagsp;->d(Ljava/lang/String;)Z"),
        "jarvis reaches non-customized promotion availability",
    )
    require_returns(
        high_investment,
        ("return-object v0", "return-object p0"),
        "non-customized high-investment rejection",
    )
    require_method_sha256(
        high_investment,
        (
            "6593c60b52194decab3acedaf64bd66b858f6a4647289d3d5f6de3883d47a763",
            "116616f8e4a64d854790cfc8cf3acfbd75360a3520d768d6bda7c0cd64050503",
        ),
        "non-customized high-investment rejection",
    )

    customized = method(
        read(decoded, "smali_classes3/agwo.smali"),
        ".method public final q()V",
    )
    require_locals(customized, 11, "customized Jarvis rejection")
    for contract in (
        "iput-object v4, p0, Lagwo;->j:Lagwm;",
        "invoke-direct {p0}, Lagwo;->s()V",
        'const-string v10, "jarvis:"',
        "Ljava/lang/String;->startsWith(Ljava/lang/String;)Z",
        "Ljava/util/Iterator;->remove()V",
        "const v5, 0x7f140abf",
        "Lanxc;->u(ILjava/util/Set;)V",
        "new-instance v4, Lagwn;",
    ):
        require(contract in customized, f"missing customized Jarvis rejection: {contract}")
    customized_equals = customized.index(
        "invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z"
    )
    customized_return = customized.index("    return-void", customized_equals)
    customized_lagwn = customized.index("new-instance v4, Lagwn;")
    require(
        customized_equals < customized_return < customized_lagwn,
        "Jarvis rejection does not return before customized Lagwn construction",
    )
    require_returns(
        customized,
        ("return-void", "return-void", "return-void"),
        "customized personalization update",
    )
    require_method_sha256(
        customized,
        (
            "a18d2b20c63f5bb149831347727c667a718c6ca03f47b2d16b1ee296e58a9420",
            "27f6a31cb2570a781868ab465f508ca7048460115b5d091c365782af9c0409ac",
        ),
        "customized personalization update",
    )

    customized_order_file = read(decoded, "smali/agrz.smali")
    customized_order_load = method(
        customized_order_file,
        ".method static n(Landroid/content/Context;Lagut;Laivh;Lazha;Lazha;Z)Lagrz;",
    )
    customized_order_migration = method(
        customized_order_file,
        ".method private static o(Lanyg;II)V",
    )
    for contract in (
        "const v5, 0x7f140935",
        "const v11, 0x7f1409c7",
        "const v8, 0x7f140934",
        "const v8, 0x7f1409c6",
        "invoke-static {v4, v5, v8}, Lagrz;->o(Lanyg;II)V",
        "invoke-static {v4, v11, v8}, Lagrz;->o(Lanyg;II)V",
    ):
        require(contract in customized_order_load, f"missing persisted order migration: {contract}")
    for contract in (
        "Lanyg;->ar(I)Z",
        "Lanyg;->S(I)Ljava/lang/String;",
        'const-string v9, "jarvis"',
        "Ljava/lang/String;->equals(Ljava/lang/Object;)Z",
        "Landroid/text/TextUtils;->join(Ljava/lang/CharSequence;Ljava/lang/Iterable;)Ljava/lang/String;",
        "Lanxc;->t(ILjava/lang/String;)V",
        "Lanxc;->l(II)I",
        "if-ltz v6",
        "if-ge v3, v6",
        "Lanxc;->r(II)V",
    ):
        require(contract in customized_order_migration, f"missing persisted order scrub: {contract}")
    require_method_sha256(
        customized_order_load,
        "23674d50c8d6ffa70763228572209d3b3c9899b6d9e6f4092d2b942d10edc0f7",
        "customized persisted order load",
    )
    require_method_sha256(
        customized_order_migration,
        (
            "0bc1daaa28b7383af717c8152b8f8e0a317ec6fca78597210e3f1656d65c8ffb",
            "a527f2f79298ab57cafbb0b2b6cb7044dd7a546413b06c632f66f27496ba60b5",
        ),
        "customized persisted order migration",
    )

    state = method(read(decoded, "smali_classes2/wok.smali"), ".method public final k()V")
    for contract in (
        "Lwok;->k:Z",
        "Lwok;->b:Z",
        "Lwok;->d:Z",
        "Lwtz;->i(Z)Z",
        "Lwok;->c:Z",
        "Lwok;->m:Z",
        "const/4 v1, 0x3",
        "const/4 v2, 0x4",
        "const/4 v1, 0x6",
        "instance-of v1, p0, Lwsc;",
        "Lwtu;->c:Lajoj;",
    ):
        require(contract in state, f"missing polish safety contract: {contract}")

    wsf = method(
        read(decoded, "smali/wsf.smali"),
        ".method public final getModuleDef(Landroid/content/Context;)Lamyy;",
    )
    wej = method(
        read(decoded, "smali/wej.smali"),
        ".method public final getModuleDef(Landroid/content/Context;)Lamyy;",
    )
    require("const-class p0, Lwse;" in wsf, "missing polish provider module")
    require("const-class v1, Lwth;" not in wsf, "polish provider still depends on Lwth")
    require("Lwtu;->r:Lajoj;" not in wsf, "polish provider gate remains")
    require("const-class p1, Lwtj;" in wej, "missing Writing Tools event consumer")
    require("const-class v1, Lwth;" not in wej, "Writing Tools event consumer still depends on Lwth")
    require("Lwtu;->c:Lajoj;" not in wej, "Writing Tools module gate remains")

    # Runtime registry cardinality cannot be proven statically. This gate proves
    # one native provider token and pre-personalization Jarvis rejection in both
    # native handlers; exact one reserve voice remains a physical ARM64 UI item.


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("apk", type=Path)
    parser.add_argument("--apktool", type=Path, required=True)
    args = parser.parse_args()

    require(args.apk.is_file(), f"missing signed APK: {args.apk}")
    require(args.apktool.is_file(), f"missing apktool: {args.apktool}")
    java = shutil.which("java")
    require(java is not None, "java is required")

    with tempfile.TemporaryDirectory(prefix="myboard-fixed-holder-", dir="/var/tmp") as directory:
        decoded = Path(directory) / "decoded"
        result = subprocess.run(
            [java, "-jar", str(args.apktool), "d", "-r", str(args.apk), "-o", str(decoded)],
            text=True,
            capture_output=True,
        )
        if result.returncode != 0:
            raise SystemExit(
                "signed APK decode failed\n"
                f"stdout:\n{result.stdout}\n"
                f"stderr:\n{result.stderr}"
            )
        verify(decoded)

    digest = hashlib.sha256(args.apk.read_bytes()).hexdigest()
    print(f"verified fixed-holder contracts {args.apk} sha256={digest}")


if __name__ == "__main__":
    main()
