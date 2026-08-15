.method public final b(Ljava/lang/String;Z)Lagpb;
    .locals 3

    .line 1
    new-instance v0, Lwsa;

    .line 2
    .line 3
    invoke-direct {v0, p0}, Lwsa;-><init>(Lwse;)V

    .line 4
    .line 5
    .line 6
    xor-int/lit8 v1, p2, 0x1

    .line 7
    .line 8
    invoke-static {v1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    .line 9
    .line 10
    .line 11
    move-result-object v1

    .line 12
    const/4 v2, 0x0

    .line 13
    invoke-static {p1, v0, v2, v1}, Lwqw;->a(Ljava/lang/String;Lagpa;Lagox;Ljava/lang/Boolean;)Lagow;

    .line 14
    .line 15
    .line 16
    move-result-object p1

    .line 17
    const v0, 0x7f14170e

    .line 18
    .line 19
    .line 20
    const v1, 0x7f14170f

    .line 21
    .line 22
    .line 23
    if-eqz p2, :cond_0

    .line 24
    .line 25
    move v2, v0

    .line 26
    goto :goto_0

    .line 27
    :cond_0
    move v2, v1

    .line 28
    :goto_0
    invoke-virtual {p1, v2}, Lagow;->l(I)V

    .line 29
    .line 30
    .line 31
    const/4 v2, 0x1

    .line 32
    if-eq v2, p2, :cond_1

    .line 33
    .line 34
    move v0, v1

    .line 35
    :cond_1
    invoke-virtual {p1, v0}, Lagow;->j(I)V

    .line 36
    .line 37
    .line 38
    new-instance v0, Lwsb;

    .line 39
    .line 40
    invoke-direct {v0, p0, p2}, Lwsb;-><init>(Lwse;Z)V

    .line 41
    .line 42
    .line 43
    invoke-virtual {p1, v0}, Lagow;->u(Ljava/lang/Runnable;)V

    .line 44
    .line 45
    .line 46
    invoke-virtual {p1}, Lagow;->b()Lagpb;

    .line 47
    .line 48
    .line 49
    move-result-object p0

    .line 50
    return-object p0
.end method
