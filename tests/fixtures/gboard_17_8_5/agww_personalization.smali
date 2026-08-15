.method public constructor <init>(Landroid/content/Context;Lagsp;)V
    .locals 3

    .line 1
    const-string v0, "usage_store_key_personalize_top_bar"

    .line 2
    .line 3
    sget-object v1, Lagpc;->j:Lajoj;

    .line 4
    .line 5
    invoke-direct {p0, p1, v0, v1}, Lagsl;-><init>(Landroid/content/Context;Ljava/lang/String;Lajoj;)V

    .line 6
    .line 7
    .line 8
    sget-object v0, Lazlp;->a:Lazlp;

    .line 9
    .line 10
    iput-object v0, p0, Lagww;->i:Lazha;

    .line 11
    .line 12
    invoke-static {p1}, Lanyg;->N(Landroid/content/Context;)Lanyg;

    .line 13
    .line 14
    .line 15
    move-result-object p1

    .line 16
    iput-object p1, p0, Lagww;->l:Lanyg;

    .line 17
    .line 18
    iput-object p2, p0, Lagww;->o:Lagsp;

    .line 19
    .line 20
    invoke-static {}, Lagww;->q()Lazha;

    .line 21
    .line 22
    .line 23
    move-result-object p2

    .line 24
    iput-object p2, p0, Lagww;->i:Lazha;

    .line 25
    .line 26
    invoke-virtual {p0}, Lagsl;->e()V

    .line 27
    .line 28
    .line 29
    const p2, 0x7f140ac1

    .line 30
    .line 31
    .line 32
    const/4 v0, 0x0

    .line 33
    invoke-virtual {p1, p2, v0}, Lanxc;->p(ILjava/util/Set;)Ljava/util/Set;

    .line 34
    .line 35
    .line 36
    move-result-object p1

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
    iput-object v0, p0, Lagww;->n:Lazha;

    .line 44
    .line 45
    sget-object p1, Lagww;->k:Lazpb;

    .line 46
    .line 47
    invoke-virtual {p1}, Lazor;->b()Lazpr;

    .line 48
    .line 49
    .line 50
    move-result-object p1

    .line 51
    check-cast p1, Lazoy;

    .line 52
    .line 53
    const/16 p2, 0x8d

    .line 54
    .line 55
    const-string v0, "PersonalizeTopBarHandler.java"

    .line 56
    .line 57
    const-string v1, "com/google/android/libraries/inputmethod/accesspoint/impl/PersonalizeTopBarHandler"

    .line 58
    .line 59
    const-string v2, "loadPersonalizedAccessPoints"

    .line 60
    .line 61
    invoke-interface {p1, v1, v2, p2, v0}, Lazoy;->j(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Lazpr;

    .line 62
    .line 63
    .line 64
    move-result-object p1

    .line 65
    check-cast p1, Lazoy;

    .line 66
    .line 67
    iget-object p0, p0, Lagww;->n:Lazha;

    .line 68
    .line 69
    const-string p2, "Load remained access points %s"

    .line 70
    .line 71
    invoke-interface {p1, p2, p0}, Lazoy;->w(Ljava/lang/String;Ljava/lang/Object;)V

    .line 72
    .line 73
    .line 74
    return-void
.end method

.method public static q()Lazha;
    .locals 2

    .line 1
    sget-object v0, Lagpc;->l:Lajoj;

    .line 2
    .line 3
    invoke-interface {v0}, Lajoj;->g()Ljava/lang/Object;

    .line 4
    .line 5
    .line 6
    move-result-object v0

    .line 7
    check-cast v0, Ljava/lang/String;

    .line 8
    .line 9
    const-string v1, ";"

    .line 10
    .line 11
    invoke-virtual {v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    .line 12
    .line 13
    .line 14
    move-result-object v0

    .line 15
    invoke-static {v0}, Lazha;->o([Ljava/lang/Object;)Lazha;

    .line 16
    .line 17
    .line 18
    move-result-object v0

    .line 19
    return-object v0
.end method

.method private final w()Ljava/lang/String;
    .locals 2

    .line 1
    sget-object v0, Lagpc;->t:Lajoj;

    .line 2
    .line 3
    invoke-interface {v0}, Lajoj;->g()Ljava/lang/Object;

    .line 4
    .line 5
    .line 6
    move-result-object v0

    .line 7
    check-cast v0, Ljava/lang/String;

    .line 8
    .line 9
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    .line 10
    .line 11
    .line 12
    move-result v1

    .line 13
    if-nez v1, :cond_0

    .line 14
    .line 15
    iget-object p0, p0, Lagww;->o:Lagsp;

    .line 16
    .line 17
    invoke-virtual {p0, v0}, Lagsp;->d(Ljava/lang/String;)Z

    .line 18
    .line 19
    .line 20
    move-result p0

    .line 21
    if-eqz p0, :cond_0

    .line 22
    .line 23
    return-object v0

    .line 24
    :cond_0
    const/4 p0, 0x0

    .line 25
    return-object p0
.end method
