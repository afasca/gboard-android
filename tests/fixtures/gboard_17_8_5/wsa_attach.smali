.method public final a(Lagpe;Landroid/view/View;)V
    .locals 2

    .line 1
    iget-object p0, p0, Lwsa;->a:Lwse;

    .line 2
    .line 3
    iget-object p1, p0, Lwse;->b:Lamua;

    .line 4
    .line 5
    iget-object p2, p0, Lwse;->c:Lj$/time/Instant;

    .line 6
    .line 7
    invoke-static {p1, p2}, Lwqw;->e(Lamua;Lj$/time/Instant;)V

    .line 8
    .line 9
    .line 10
    invoke-static {}, Lj$/time/Instant;->now()Lj$/time/Instant;

    .line 11
    .line 12
    .line 13
    move-result-object p1

    .line 14
    iput-object p1, p0, Lwse;->c:Lj$/time/Instant;

    .line 15
    .line 16
    invoke-virtual {p0}, Lajki;->ae()Lajlf;

    .line 17
    .line 18
    .line 19
    move-result-object p0

    .line 20
    new-instance p1, Lamov;

    .line 21
    .line 22
    const/4 p2, 0x0

    .line 23
    sget-object v0, Lamtk;->c:Lamtk;

    .line 24
    .line 25
    const/16 v1, -0x27f9

    .line 26
    .line 27
    invoke-direct {p1, v1, p2, v0}, Lamov;-><init>(ILamou;Ljava/lang/Object;)V

    .line 28
    .line 29
    .line 30
    invoke-static {p1}, Lajju;->d(Lamov;)Lajju;

    .line 31
    .line 32
    .line 33
    move-result-object p1

    .line 34
    invoke-interface {p0, p1}, Lajlf;->P(Lajju;)V

    .line 35
    .line 36
    .line 37
    return-void
.end method
