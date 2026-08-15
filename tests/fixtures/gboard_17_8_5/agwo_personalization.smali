.method public final q()V
    .locals 10

    .line 1
    const/4 v0, -0x1

    .line 2
    iput v0, p0, Lagsl;->h:I

    .line 3
    .line 4
    sget-object v0, Lagpc;->t:Lajoj;

    .line 5
    .line 6
    invoke-interface {v0}, Lajoj;->g()Ljava/lang/Object;

    .line 7
    .line 8
    .line 9
    move-result-object v0

    .line 10
    check-cast v0, Ljava/lang/String;

    .line 11
    .line 12
    sget-object v1, Lagpc;->u:Lajoj;

    .line 13
    .line 14
    invoke-interface {v1}, Lajoj;->g()Ljava/lang/Object;

    .line 15
    .line 16
    .line 17
    move-result-object v1

    .line 18
    check-cast v1, Ljava/lang/Long;

    .line 19
    .line 20
    invoke-virtual {v1}, Ljava/lang/Long;->longValue()J

    .line 21
    .line 22
    .line 23
    move-result-wide v2

    .line 24
    iget-object v4, p0, Lagwo;->b:Landroid/content/Context;

    .line 25
    .line 26
    const v5, 0x7f1404b3

    .line 27
    .line 28
    .line 29
    invoke-virtual {v4, v5}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    .line 30
    .line 31
    .line 32
    move-result-object v4

    .line 33
    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    .line 34
    .line 35
    .line 36
    move-result v4

    .line 37
    const-string v5, "CustomizedOrderPersonalizeTopBarHandler.java"

    .line 38
    .line 39
    const-string v6, "com/google/android/libraries/inputmethod/accesspoint/impl/CustomizedOrderPersonalizeTopBarHandler"

    .line 40
    .line 41
    const/4 v7, 0x0

    .line 42
    if-eqz v4, :cond_0

    .line 43
    .line 44
    const v4, 0x7f140b36

    .line 45
    .line 46
    .line 47
    goto :goto_0

    .line 48
    :cond_0
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    .line 49
    .line 50
    .line 51
    move-result v4

    .line 52
    if-nez v4, :cond_1

    .line 53
    .line 54
    sget-object v4, Lagwo;->i:Lazpb;

    .line 55
    .line 56
    invoke-virtual {v4}, Lazor;->c()Lazpr;

    .line 57
    .line 58
    .line 59
    move-result-object v4

    .line 60
    check-cast v4, Lazoy;

    .line 61
    .line 62
    const-string v8, "getPromoteBannerLabel"

    .line 63
    .line 64
    const/16 v9, 0x8a

    .line 65
    .line 66
    invoke-interface {v4, v6, v8, v9, v5}, Lazoy;->j(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Lazpr;

    .line 67
    .line 68
    .line 69
    move-result-object v4

    .line 70
    check-cast v4, Lazoy;

    .line 71
    .line 72
    const-string v8, "Unsupported high investment feature: %s"

    .line 73
    .line 74
    invoke-interface {v4, v8, v0}, Lazoy;->w(Ljava/lang/String;Ljava/lang/Object;)V

    .line 75
    .line 76
    .line 77
    :cond_1
    move v4, v7

    .line 78
    :goto_0
    const-string v8, "updatePromotedHighInvestmentFeature"

    .line 79
    .line 80
    if-nez v4, :cond_2

    .line 81
    .line 82
    const/4 v0, 0x0

    .line 83
    iput-object v0, p0, Lagwo;->o:Lagwn;

    .line 84
    .line 85
    iput-boolean v7, p0, Lagwo;->p:Z

    .line 86
    .line 87
    invoke-direct {p0}, Lagwo;->s()V

    .line 88
    .line 89
    .line 90
    sget-object p0, Lagwo;->i:Lazpb;

    .line 91
    .line 92
    invoke-virtual {p0}, Lazor;->b()Lazpr;

    .line 93
    .line 94
    .line 95
    move-result-object p0

    .line 96
    check-cast p0, Lazoy;

    .line 97
    .line 98
    const/16 v0, 0x72

    .line 99
    .line 100
    invoke-interface {p0, v6, v8, v0, v5}, Lazoy;->j(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Lazpr;

    .line 101
    .line 102
    .line 103
    move-result-object p0

    .line 104
    check-cast p0, Lazoy;

    .line 105
    .line 106
    const-string v0, "The high investment feature is null"

    .line 107
    .line 108
    invoke-interface {p0, v0}, Lazoy;->t(Ljava/lang/String;)V

    .line 109
    .line 110
    .line 111
    return-void

    .line 112
    :cond_2
    new-instance v4, Lagwn;

    .line 113
    .line 114
    invoke-direct {v4, v0, v2, v3}, Lagwn;-><init>(Ljava/lang/String;J)V

    .line 115
    .line 116
    .line 117
    iput-object v4, p0, Lagwo;->o:Lagwn;

    .line 118
    .line 119
    iget-object v2, p0, Lagwo;->m:Lanyg;

    .line 120
    .line 121
    const v3, 0x7f140abf

    .line 122
    .line 123
    .line 124
    invoke-virtual {v2, v3}, Lanyg;->V(I)Ljava/util/Set;

    .line 125
    .line 126
    .line 127
    move-result-object v3

    .line 128
    iget-object v4, p0, Lagwo;->o:Lagwn;

    .line 129
    .line 130
    invoke-virtual {v4}, Lagwn;->a()Ljava/lang/String;

    .line 131
    .line 132
    .line 133
    move-result-object v4

    .line 134
    invoke-interface {v3, v4}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    .line 135
    .line 136
    .line 137
    move-result v3

    .line 138
    iput-boolean v3, p0, Lagwo;->p:Z

    .line 139
    .line 140
    sget-object v3, Lagwo;->i:Lazpb;

    .line 141
    .line 142
    invoke-virtual {v3}, Lazor;->b()Lazpr;

    .line 143
    .line 144
    .line 145
    move-result-object v3

    .line 146
    check-cast v3, Lazoy;

    .line 147
    .line 148
    const/16 v4, 0x78

    .line 149
    .line 150
    invoke-interface {v3, v6, v8, v4, v5}, Lazoy;->j(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Lazpr;

    .line 151
    .line 152
    .line 153
    move-result-object v3

    .line 154
    check-cast v3, Lazoy;

    .line 155
    .line 156
    iget-boolean v4, p0, Lagwo;->p:Z

    .line 157
    .line 158
    invoke-static {v4}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    .line 159
    .line 160
    .line 161
    move-result-object v4

    .line 162
    const-string v5, "The high investment feature: %s, version= %d, hasPromoted %b"

    .line 163
    .line 164
    invoke-interface {v3, v5, v0, v1, v4}, Lazoy;->M(Ljava/lang/String;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)V

    .line 165
    .line 166
    .line 167
    const v1, 0x7f14095d

    .line 168
    .line 169
    .line 170
    const-string v3, ""

    .line 171
    .line 172
    invoke-virtual {v2, v1, v3}, Lanxc;->o(ILjava/lang/String;)Ljava/lang/String;

    .line 173
    .line 174
    .line 175
    move-result-object v1

    .line 176
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    .line 177
    .line 178
    .line 179
    move-result v0

    .line 180
    if-nez v0, :cond_3

    .line 181
    .line 182
    invoke-direct {p0}, Lagwo;->s()V

    .line 183
    .line 184
    .line 185
    :cond_3
    return-void
.end method
