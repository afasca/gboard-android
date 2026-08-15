.method public final run()V
    .locals 5

    .line 1
    iget-boolean v0, p0, Lwsb;->b:Z

    .line 2
    .line 3
    iget-object p0, p0, Lwsb;->a:Lwse;

    .line 4
    .line 5
    if-nez v0, :cond_0

    .line 6
    .line 7
    invoke-virtual {p0}, Lajki;->ac()Landroid/content/Context;

    .line 8
    .line 9
    .line 10
    move-result-object v1

    .line 11
    new-instance v2, Lwrx;

    .line 12
    .line 13
    invoke-direct {v2, p0}, Lwrx;-><init>(Lwse;)V

    .line 14
    .line 15
    .line 16
    invoke-virtual {p0}, Lajki;->ae()Lajlf;

    .line 17
    .line 18
    .line 19
    move-result-object v3

    .line 20
    const v4, 0x7f140562

    .line 21
    .line 22
    .line 23
    invoke-static {v1, v4, v2, v3}, Lagpq;->c(Landroid/content/Context;ILjava/lang/Runnable;Lajlf;)Z

    .line 24
    .line 25
    .line 26
    move-result v1

    .line 27
    if-eqz v1, :cond_0

    .line 28
    .line 29
    return-void

    .line 30
    :cond_0
    invoke-static {}, Lwtz;->h()Z

    .line 31
    .line 32
    .line 33
    move-result v1

    .line 34
    if-nez v1, :cond_2

    .line 35
    .line 36
    invoke-virtual {p0}, Lajki;->ac()Landroid/content/Context;

    .line 37
    .line 38
    .line 39
    move-result-object v0

    .line 40
    if-eqz v0, :cond_1

    .line 41
    .line 42
    goto :goto_0

    .line 43
    :cond_1
    invoke-virtual {p0}, Lajki;->ab()Landroid/content/Context;

    .line 44
    .line 45
    .line 46
    move-result-object v0

    .line 47
    :goto_0
    invoke-static {v0}, Lwqw;->d(Landroid/content/Context;)V

    .line 48
    .line 49
    .line 50
    return-void

    .line 51
    :cond_2
    invoke-static {}, Lagng;->y()Z

    .line 52
    .line 53
    .line 54
    move-result v1

    .line 55
    if-nez v1, :cond_4

    .line 56
    .line 57
    if-nez v0, :cond_3

    .line 58
    .line 59
    invoke-virtual {p0}, Lajki;->ae()Lajlf;

    .line 60
    .line 61
    .line 62
    move-result-object v0

    .line 63
    const/16 v1, -0x274c

    .line 64
    .line 65
    const/4 v2, 0x0

    .line 66
    invoke-static {v1, v2}, Lajju;->e(ILjava/lang/Object;)Lajju;

    .line 67
    .line 68
    .line 69
    move-result-object v1

    .line 70
    invoke-interface {v0, v1}, Lajlf;->P(Lajju;)V

    .line 71
    .line 72
    .line 73
    sget-object v0, Lajkj;->d:Lajkj;

    .line 74
    .line 75
    sget-object v1, Lbajq;->m:Lbajq;

    .line 76
    .line 77
    invoke-static {v1}, Laodi;->d(Lbajq;)Laodi;

    .line 78
    .line 79
    .line 80
    move-result-object v1

    .line 81
    new-instance v2, Lwrz;

    .line 82
    .line 83
    invoke-direct {v2, p0}, Lwrz;-><init>(Lwse;)V

    .line 84
    .line 85
    .line 86
    const/4 p0, 0x0

    .line 87
    invoke-static {v0, v1, p0, v2}, Lwtz;->e(Lajkj;Laodi;ZLjava/util/function/Consumer;)V

    .line 88
    .line 89
    .line 90
    return-void

    .line 91
    :cond_3
    invoke-virtual {p0}, Lwse;->s()V

    .line 92
    .line 93
    .line 94
    return-void

    .line 95
    :cond_4
    invoke-virtual {p0}, Lwse;->v()V

    .line 96
    .line 97
    .line 98
    return-void
.end method
