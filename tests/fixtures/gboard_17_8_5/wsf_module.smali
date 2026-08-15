.method public final getModuleDef(Landroid/content/Context;)Lamyy;
    .locals 3

    .line 1
    const-class p0, Lwse;

    .line 2
    .line 3
    sget-object p1, Lamyx;->b:Lamyx;

    .line 4
    .line 5
    new-instance v0, Lamyw;

    .line 6
    .line 7
    const/16 v1, 0xf5

    .line 8
    .line 9
    invoke-direct {v0, v1, p0, p0, p1}, Lamyw;-><init>(ILjava/lang/Class;Ljava/lang/Class;Lamyx;)V

    .line 10
    .line 11
    .line 12
    sget-object p0, Lamyp;->a:Lazpb;

    .line 13
    .line 14
    new-instance p0, Lamym;

    .line 15
    .line 16
    invoke-direct {p0}, Lamym;-><init>()V

    .line 17
    .line 18
    .line 19
    const/4 p1, 0x1

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
    sget-object p1, Lwtu;->r:Lajoj;

    .line 31
    .line 32
    invoke-virtual {p0, p1}, Lamym;->k(Lajoj;)V

    .line 33
    .line 34
    .line 35
    iput-object p0, v0, Lamyw;->f:Lamym;

    .line 36
    .line 37
    new-instance p0, Lamyy;

    .line 38
    .line 39
    invoke-direct {p0, v0}, Lamyy;-><init>(Lamyw;)V

    .line 40
    .line 41
    .line 42
    return-object p0
.end method
