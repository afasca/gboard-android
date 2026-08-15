.method public final getModuleDef(Landroid/content/Context;)Lamyy;
    .locals 5

    .line 1
    new-instance p0, Lamyq;

    .line 2
    .line 3
    invoke-direct {p0}, Lamyq;-><init>()V

    .line 4
    .line 5
    .line 6
    sget-object p1, Lwtv;->a:Lamrh;

    .line 7
    .line 8
    invoke-virtual {p0, p1}, Lamyq;->b(Lamrh;)V

    .line 9
    .line 10
    .line 11
    const-class p1, Lwtj;

    .line 12
    .line 13
    const-class v0, Lwei;

    .line 14
    .line 15
    sget-object v1, Lamyx;->b:Lamyx;

    .line 16
    .line 17
    new-instance v2, Lamyw;

    .line 18
    .line 19
    const/16 v3, 0x6c

    .line 20
    .line 21
    invoke-direct {v2, v3, p1, v0, v1}, Lamyw;-><init>(ILjava/lang/Class;Ljava/lang/Class;Lamyx;)V

    .line 22
    .line 23
    .line 24
    sget-object p1, Lamyp;->a:Lazpb;

    .line 25
    .line 26
    new-instance p1, Lamym;

    .line 27
    .line 28
    invoke-direct {p1}, Lamym;-><init>()V

    .line 29
    .line 30
    .line 31
    const/4 v0, 0x2

    .line 32
    new-array v0, v0, [Langv;

    .line 33
    .line 34
    sget-object v1, Laliq;->c:Langv;

    .line 35
    .line 36
    const/4 v3, 0x0

    .line 37
    aput-object v1, v0, v3

    .line 38
    .line 39
    sget-object v1, Laooc;->a:Laooc;

    .line 40
    .line 41
    const/4 v4, 0x1

    .line 42
    aput-object v1, v0, v4

    .line 43
    .line 44
    invoke-virtual {p1, v0}, Lamym;->h([Langv;)V

    .line 45
    .line 46
    .line 47
    new-array v0, v4, [Ljava/lang/Class;

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
    sget-object v0, Lwtu;->c:Lajoj;

    .line 57
    .line 58
    invoke-virtual {p1, v0}, Lamym;->k(Lajoj;)V

    .line 59
    .line 60
    .line 61
    iput-object p1, v2, Lamyw;->f:Lamym;

    .line 62
    .line 63
    iput-object p0, v2, Lamyw;->e:Lamyq;

    .line 64
    .line 65
    new-instance p0, Lamyy;

    .line 66
    .line 67
    invoke-direct {p0, v2}, Lamyy;-><init>(Lamyw;)V

    .line 68
    .line 69
    .line 70
    return-object p0
.end method
