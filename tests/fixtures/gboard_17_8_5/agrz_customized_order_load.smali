.method static n(Landroid/content/Context;Lagut;Laivh;Lazha;Lazha;Z)Lagrz;
    .locals 16

    .line 1
    move-object/from16 v0, p0

    .line 2
    .line 3
    move-object/from16 v1, p1

    .line 4
    .line 5
    move-object/from16 v2, p2

    .line 6
    .line 7
    move-object/from16 v3, p3

    .line 8
    .line 9
    invoke-static {v0}, Lanyg;->N(Landroid/content/Context;)Lanyg;

    .line 10
    .line 11
    .line 12
    move-result-object v4

    .line 13
    const v5, 0x7f140935

    .line 14
    .line 15
    .line 16
    invoke-virtual {v4, v5}, Lanyg;->ar(I)Z

    .line 17
    .line 18
    .line 19
    move-result v6

    .line 20
    const-string v7, ";"

    .line 21
    .line 22
    const/4 v8, 0x0

    .line 23
    const/4 v9, 0x0

    .line 24
    if-eqz v6, :cond_0

    .line 25
    .line 26
    goto :goto_0

    .line 27
    :cond_0
    const-string v6, "pref_key_access_points_showing_order"

    .line 28
    .line 29
    invoke-virtual {v4, v6, v9}, Leai;->d(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    .line 30
    .line 31
    .line 32
    move-result-object v10

    .line 33
    invoke-static {v10}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    .line 34
    .line 35
    .line 36
    move-result v11

    .line 37
    if-nez v11, :cond_4

    .line 38
    .line 39
    invoke-virtual {v10, v7}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    .line 40
    .line 41
    .line 42
    move-result-object v10

    .line 43
    new-instance v11, Lagrx;

    .line 44
    .line 45
    invoke-direct {v11}, Ljava/lang/Object;-><init>()V

    .line 46
    .line 47
    .line 48
    invoke-static {v10, v11, v3}, Lagrz;->c([Ljava/lang/String;Laywg;Lazha;)Lazfk;

    .line 49
    .line 50
    .line 51
    move-result-object v10

    .line 52
    invoke-virtual {v10}, Lazfk;->isEmpty()Z

    .line 53
    .line 54
    .line 55
    move-result v11

    .line 56
    if-nez v11, :cond_3

    .line 57
    .line 58
    invoke-static {v3}, Lagsr;->q(Lazha;)Lazfk;

    .line 59
    .line 60
    .line 61
    move-result-object v11

    .line 62
    if-nez v11, :cond_1

    .line 63
    .line 64
    invoke-static {v0, v3}, Lagsr;->p(Landroid/content/Context;Lazha;)Lazfk;

    .line 65
    .line 66
    .line 67
    move-result-object v11

    .line 68
    :cond_1
    invoke-static {v11, v10}, Lazin;->g(Ljava/util/List;Ljava/lang/Object;)Z

    .line 69
    .line 70
    .line 71
    move-result v11

    .line 72
    if-nez v11, :cond_3

    .line 73
    .line 74
    sget-object v11, Lagrz;->d:Lazfk;

    .line 75
    .line 76
    move-object v12, v11

    .line 77
    check-cast v12, Lazlj;

    .line 78
    .line 79
    iget v12, v12, Lazlj;->c:I

    .line 80
    .line 81
    invoke-virtual {v10}, Lazfk;->size()I

    .line 82
    .line 83
    .line 84
    move-result v13

    .line 85
    if-lt v13, v12, :cond_2

    .line 86
    .line 87
    invoke-virtual {v10, v8, v12}, Lazfk;->c(II)Lazfk;

    .line 88
    .line 89
    .line 90
    move-result-object v12

    .line 91
    invoke-static {v12, v11}, Lazin;->g(Ljava/util/List;Ljava/lang/Object;)Z

    .line 92
    .line 93
    .line 94
    move-result v11

    .line 95
    if-nez v11, :cond_3

    .line 96
    .line 97
    :cond_2
    sget-object v11, Laivh;->i:Laivh;

    .line 98
    .line 99
    invoke-static {v0, v11, v10}, Lagsn;->q(Landroid/content/Context;Laivh;Ljava/util/List;)V

    .line 100
    .line 101
    .line 102
    :cond_3
    invoke-virtual {v4, v6}, Lanyg;->w(Ljava/lang/String;)V

    .line 103
    .line 104
    .line 105
    :cond_4
    :goto_0
    invoke-static {v0}, Lanyg;->N(Landroid/content/Context;)Lanyg;

    .line 106
    .line 107
    .line 108
    move-result-object v4

    .line 109
    const v6, 0x7f1409c6

    .line 110
    .line 111
    .line 112
    const v10, 0x7f1409de

    .line 113
    .line 114
    .line 115
    const v11, 0x7f1409c7

    .line 116
    .line 117
    .line 118
    if-nez p5, :cond_5

    .line 119
    .line 120
    invoke-virtual {v4, v10}, Lanxc;->v(I)V

    .line 121
    .line 122
    .line 123
    invoke-virtual {v4, v11}, Lanxc;->v(I)V

    .line 124
    .line 125
    .line 126
    invoke-virtual {v4, v6}, Lanxc;->v(I)V

    .line 127
    .line 128
    .line 129
    goto :goto_1

    .line 130
    :cond_5
    sget-object v12, Laivl;->a:Lajoj;

    .line 131
    .line 132
    invoke-static {v0}, Lanyg;->N(Landroid/content/Context;)Lanyg;

    .line 133
    .line 134
    .line 135
    move-result-object v12

    .line 136
    const-string v13, "is_foldable_device"

    .line 137
    .line 138
    invoke-virtual {v12, v13}, Lanyg;->au(Ljava/lang/String;)Z

    .line 139
    .line 140
    .line 141
    move-result v12

    .line 142
    if-eqz v12, :cond_8

    .line 143
    .line 144
    invoke-virtual {v4, v10}, Lanyg;->at(I)Z

    .line 145
    .line 146
    .line 147
    move-result v12

    .line 148
    if-nez v12, :cond_8

    .line 149
    .line 150
    sget-object v12, Lagrz;->c:Lazpb;

    .line 151
    .line 152
    invoke-virtual {v12}, Lazor;->b()Lazpr;

    .line 153
    .line 154
    .line 155
    move-result-object v12

    .line 156
    check-cast v12, Lazoy;

    .line 157
    .line 158
    const/16 v13, 0x91

    .line 159
    .line 160
    const-string v14, "AbstractAccessPointOrder.java"

    .line 161
    .line 162
    const-string v15, "com/google/android/libraries/inputmethod/accesspoint/impl/AbstractAccessPointOrder"

    .line 163
    .line 164
    const-string v8, "migrateCustomizedAccessPointsOrderForFoldable"

    .line 165
    .line 166
    invoke-interface {v12, v15, v8, v13, v14}, Lazoy;->j(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Lazpr;

    .line 167
    .line 168
    .line 169
    move-result-object v8

    .line 170
    check-cast v8, Lazoy;

    .line 171
    .line 172
    const-string v12, "Migrate customized order for foldable"

    .line 173
    .line 174
    invoke-interface {v8, v12}, Lazoy;->t(Ljava/lang/String;)V

    .line 175
    .line 176
    .line 177
    const/4 v8, 0x1

    .line 178
    invoke-virtual {v4, v10, v8}, Lanxc;->q(IZ)V

    .line 179
    .line 180
    .line 181
    invoke-virtual {v4, v11}, Lanyg;->ar(I)Z

    .line 182
    .line 183
    .line 184
    move-result v8

    .line 185
    if-nez v8, :cond_8

    .line 186
    .line 187
    invoke-virtual {v4, v5}, Lanyg;->S(I)Ljava/lang/String;

    .line 188
    .line 189
    .line 190
    move-result-object v8

    .line 191
    invoke-static {v8}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    .line 192
    .line 193
    .line 194
    move-result v10

    .line 195
    if-nez v10, :cond_6

    .line 196
    .line 197
    invoke-virtual {v4, v11, v8}, Lanxc;->t(ILjava/lang/String;)V

    .line 198
    .line 199
    .line 200
    :cond_6
    const v8, 0x7f140934

    .line 201
    .line 202
    .line 203
    invoke-virtual {v4, v8}, Lanyg;->ar(I)Z

    .line 204
    .line 205
    .line 206
    move-result v10

    .line 207
    const/4 v12, -0x1

    .line 208
    if-eqz v10, :cond_7

    .line 209
    .line 210
    invoke-virtual {v4, v8, v12}, Lanxc;->l(II)I

    .line 211
    .line 212
    .line 213
    move-result v12

    .line 214
    :cond_7
    if-ltz v12, :cond_8

    .line 215
    .line 216
    invoke-virtual {v4, v6, v12}, Lanxc;->r(II)V

    .line 217
    .line 218
    .line 219
    :cond_8
    :goto_1
    sget v4, Lagsn;->e:I

    .line 220
    .line 221
    invoke-static {v0}, Lanyg;->N(Landroid/content/Context;)Lanyg;

    .line 222
    .line 223
    .line 224
    move-result-object v4

    .line 225
    sget-object v6, Laivh;->f:Laivh;

    .line 226
    .line 227
    if-ne v2, v6, :cond_9

    .line 228
    .line 229
    move v5, v11

    .line 230
    :cond_9
    invoke-virtual {v4, v5}, Lanyg;->S(I)Ljava/lang/String;

    .line 231
    .line 232
    .line 233
    move-result-object v4

    .line 234
    invoke-static {v4}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    .line 235
    .line 236
    .line 237
    move-result v5

    .line 238
    if-eqz v5, :cond_a

    .line 239
    .line 240
    move-object v4, v9

    .line 241
    goto :goto_2

    .line 242
    :cond_a
    invoke-virtual {v4, v7}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    .line 243
    .line 244
    .line 245
    move-result-object v4

    .line 246
    invoke-static {v4, v9, v3}, Lagrz;->c([Ljava/lang/String;Laywg;Lazha;)Lazfk;

    .line 247
    .line 248
    .line 249
    move-result-object v4

    .line 250
    :goto_2
    if-eqz v4, :cond_f

    .line 251
    .line 252
    invoke-virtual {v4}, Lazfk;->isEmpty()Z

    .line 253
    .line 254
    .line 255
    move-result v5

    .line 256
    if-eqz v5, :cond_b

    .line 257
    .line 258
    goto :goto_5

    .line 259
    :cond_b
    invoke-static {v0, v3}, Lagsr;->p(Landroid/content/Context;Lazha;)Lazfk;

    .line 260
    .line 261
    .line 262
    move-result-object v5

    .line 263
    new-instance v6, Ljava/util/ArrayList;

    .line 264
    .line 265
    invoke-direct {v6, v4}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 266
    .line 267
    .line 268
    invoke-interface {v5}, Ljava/util/List;->size()I

    .line 269
    .line 270
    .line 271
    move-result v7

    .line 272
    const/4 v8, 0x0

    .line 273
    const/4 v9, 0x0

    .line 274
    :goto_3
    if-ge v8, v7, :cond_e

    .line 275
    .line 276
    invoke-interface {v5, v8}, Ljava/util/List;->get(I)Ljava/lang/Object;

    .line 277
    .line 278
    .line 279
    move-result-object v10

    .line 280
    check-cast v10, Ljava/lang/String;

    .line 281
    .line 282
    invoke-virtual {v4, v10}, Lazfk;->contains(Ljava/lang/Object;)Z

    .line 283
    .line 284
    .line 285
    move-result v11

    .line 286
    if-nez v11, :cond_d

    .line 287
    .line 288
    invoke-interface {v6}, Ljava/util/List;->size()I

    .line 289
    .line 290
    .line 291
    move-result v11

    .line 292
    if-ge v9, v11, :cond_c

    .line 293
    .line 294
    invoke-interface {v6, v9, v10}, Ljava/util/List;->add(ILjava/lang/Object;)V

    .line 295
    .line 296
    .line 297
    goto :goto_4

    .line 298
    :cond_c
    invoke-interface {v6, v10}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 299
    .line 300
    .line 301
    :cond_d
    :goto_4
    add-int/lit8 v8, v8, 0x1

    .line 302
    .line 303
    add-int/lit8 v9, v9, 0x1

    .line 304
    .line 305
    goto :goto_3

    .line 306
    :cond_e
    invoke-static {v6}, Lazfk;->k(Ljava/util/Collection;)Lazfk;

    .line 307
    .line 308
    .line 309
    move-result-object v9

    .line 310
    :cond_f
    :goto_5
    if-eqz v9, :cond_10

    .line 311
    .line 312
    new-instance v3, Lagsn;

    .line 313
    .line 314
    invoke-direct {v3, v0, v1, v2, v9}, Lagsn;-><init>(Landroid/content/Context;Lagut;Laivh;Ljava/util/List;)V

    .line 315
    .line 316
    .line 317
    goto :goto_6

    .line 318
    :cond_10
    new-instance v2, Lagsr;

    .line 319
    .line 320
    invoke-direct {v2, v0, v1, v3}, Lagsr;-><init>(Landroid/content/Context;Lagut;Lazha;)V

    .line 321
    .line 322
    .line 323
    move-object v3, v2

    .line 324
    :goto_6
    invoke-virtual/range {p4 .. p4}, Lazha;->l()Lazni;

    .line 325
    .line 326
    .line 327
    move-result-object v0

    .line 328
    :goto_7
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    .line 329
    .line 330
    .line 331
    move-result v1

    .line 332
    if-eqz v1, :cond_11

    .line 333
    .line 334
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 335
    .line 336
    .line 337
    move-result-object v1

    .line 338
    check-cast v1, Ljava/lang/String;

    .line 339
    .line 340
    invoke-virtual {v3, v1}, Lagrz;->f(Ljava/lang/String;)V

    .line 341
    .line 342
    .line 343
    goto :goto_7

    .line 344
    :cond_11
    return-object v3
.end method


# virtual methods
