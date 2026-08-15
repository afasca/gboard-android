.method private final d(Z)Lagow;
    .locals 3

    .line 1
    invoke-static {}, Lagpb;->l()Lagow;

    .line 2
    .line 3
    .line 4
    move-result-object v0

    .line 5
    invoke-static {v0}, Latbs;->g(Lagow;)V

    .line 6
    .line 7
    .line 8
    iget-object v1, p0, Lshb;->h:Ljava/lang/String;

    .line 9
    .line 10
    invoke-virtual {v0, v1}, Lagow;->o(Ljava/lang/String;)V

    .line 11
    .line 12
    .line 13
    const v1, 0x7f1406b9

    .line 14
    .line 15
    .line 16
    invoke-virtual {v0, v1}, Lagow;->l(I)V

    .line 17
    .line 18
    .line 19
    sget-object v1, Lagpe;->i:Lagpe;

    .line 20
    .line 21
    const/4 v2, 0x0

    .line 22
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 23
    .line 24
    .line 25
    move-result-object v2

    .line 26
    invoke-static {v1, v2}, Lazfv;->l(Ljava/lang/Object;Ljava/lang/Object;)Lazfv;

    .line 27
    .line 28
    .line 29
    move-result-object v1

    .line 30
    const-string v2, "holder_specific_layout"

    .line 31
    .line 32
    invoke-virtual {v0, v2, v1}, Lagow;->e(Ljava/lang/String;Ljava/lang/Object;)V

    .line 33
    .line 34
    .line 35
    const/4 v1, 0x1

    .line 36
    invoke-static {v1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    .line 37
    .line 38
    .line 39
    move-result-object v1

    .line 40
    const-string v2, "default"

    .line 41
    .line 42
    invoke-virtual {v0, v2, v1}, Lagow;->e(Ljava/lang/String;Ljava/lang/Object;)V

    .line 43
    .line 44
    .line 45
    new-instance v1, Lsgw;

    .line 46
    .line 47
    invoke-direct {v1, p0, p1}, Lsgw;-><init>(Lshb;Z)V

    .line 48
    .line 49
    .line 50
    move-object v2, v0

    .line 51
    check-cast v2, Lagpt;

    .line 52
    .line 53
    iput-object v1, v2, Lagpt;->h:Lagoz;

    .line 54
    .line 55
    new-instance v1, Lsgx;

    .line 56
    .line 57
    invoke-direct {v1, p0, p1}, Lsgx;-><init>(Lshb;Z)V

    .line 58
    .line 59
    .line 60
    iput-object v1, v2, Lagpt;->i:Lagoy;

    .line 61
    .line 62
    return-object v0
.end method

.method public final b(I)V
    .locals 12

    .line 1
    iput p1, p0, Lshb;->c:I

    .line 2
    .line 3
    iget-object v0, p0, Lshb;->d:Landroid/view/inputmethod/EditorInfo;

    .line 4
    .line 5
    if-nez v0, :cond_0

    .line 6
    .line 7
    goto/16 :goto_1

    .line 8
    .line 9
    :cond_0
    iget-object v0, p0, Lshb;->a:Landroid/content/Context;

    .line 10
    .line 11
    sget-object v1, Laqmo;->a:Lajog;

    .line 12
    .line 13
    invoke-virtual {v1, v0}, Lajog;->d(Landroid/content/Context;)Lajoj;

    .line 14
    .line 15
    .line 16
    move-result-object v0

    .line 17
    invoke-interface {v0}, Lajoj;->g()Ljava/lang/Object;

    .line 18
    .line 19
    .line 20
    move-result-object v0

    .line 21
    check-cast v0, Ljava/lang/Boolean;

    .line 22
    .line 23
    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    .line 24
    .line 25
    .line 26
    move-result v0

    .line 27
    const v1, 0x7f0b2a91

    .line 28
    .line 29
    .line 30
    if-nez v0, :cond_1

    .line 31
    .line 32
    iget-object v2, p0, Lshb;->h:Ljava/lang/String;

    .line 33
    .line 34
    invoke-static {v1, v2}, Lagpz;->a(ILjava/lang/String;)V

    .line 35
    .line 36
    .line 37
    :cond_1
    and-int/lit8 v2, p1, 0x8

    .line 38
    .line 39
    const/16 v3, 0x8

    .line 40
    .line 41
    const/4 v4, 0x0

    .line 42
    const/4 v5, 0x0

    .line 43
    if-ne v2, v3, :cond_2

    .line 44
    .line 45
    goto/16 :goto_0

    .line 46
    .line 47
    :cond_2
    and-int/lit8 v2, p1, 0x10

    .line 48
    .line 49
    const v3, 0x7f0e06f4

    .line 50
    .line 51
    .line 52
    const v6, 0x7f0401ac

    .line 53
    .line 54
    .line 55
    const v7, 0x7f1416df

    .line 56
    .line 57
    .line 58
    const/16 v8, 0x10

    .line 59
    .line 60
    const-string v9, "layout"

    .line 61
    .line 62
    if-ne v2, v8, :cond_3

    .line 63
    .line 64
    iget-object p1, p0, Lshb;->i:Landroid/util/SparseArray;

    .line 65
    .line 66
    invoke-virtual {p1, v8}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    .line 67
    .line 68
    .line 69
    move-result-object v2

    .line 70
    move-object v4, v2

    .line 71
    check-cast v4, Lagpb;

    .line 72
    .line 73
    if-nez v4, :cond_8

    .line 74
    .line 75
    invoke-direct {p0, v5}, Lshb;->d(Z)Lagow;

    .line 76
    .line 77
    .line 78
    move-result-object v2

    .line 79
    invoke-virtual {v2, v6}, Lagow;->k(I)V

    .line 80
    .line 81
    .line 82
    invoke-virtual {v2, v7}, Lagow;->j(I)V

    .line 83
    .line 84
    .line 85
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 86
    .line 87
    .line 88
    move-result-object v3

    .line 89
    invoke-virtual {v2, v9, v3}, Lagow;->e(Ljava/lang/String;Ljava/lang/Object;)V

    .line 90
    .line 91
    .line 92
    invoke-virtual {v2, v7}, Lagow;->n(I)V

    .line 93
    .line 94
    .line 95
    invoke-virtual {v2}, Lagow;->b()Lagpb;

    .line 96
    .line 97
    .line 98
    move-result-object v4

    .line 99
    invoke-virtual {p1, v8, v4}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 100
    .line 101
    .line 102
    goto/16 :goto_0

    .line 103
    .line 104
    :cond_3
    and-int/lit8 v2, p1, 0x20

    .line 105
    .line 106
    const v8, 0x7f0e0704

    .line 107
    .line 108
    .line 109
    const/16 v10, 0x20

    .line 110
    .line 111
    const/4 v11, 0x1

    .line 112
    if-ne v2, v10, :cond_4

    .line 113
    .line 114
    iget-object p1, p0, Lshb;->i:Landroid/util/SparseArray;

    .line 115
    .line 116
    invoke-virtual {p1, v10}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    .line 117
    .line 118
    .line 119
    move-result-object v2

    .line 120
    move-object v4, v2

    .line 121
    check-cast v4, Lagpb;

    .line 122
    .line 123
    if-nez v4, :cond_8

    .line 124
    .line 125
    invoke-direct {p0, v11}, Lshb;->d(Z)Lagow;

    .line 126
    .line 127
    .line 128
    move-result-object v2

    .line 129
    invoke-static {v2, v11}, Latbs;->f(Lagow;Z)V

    .line 130
    .line 131
    .line 132
    invoke-virtual {v2, v6}, Lagow;->k(I)V

    .line 133
    .line 134
    .line 135
    invoke-virtual {v2, v7}, Lagow;->j(I)V

    .line 136
    .line 137
    .line 138
    invoke-static {v8}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 139
    .line 140
    .line 141
    move-result-object v3

    .line 142
    invoke-virtual {v2, v9, v3}, Lagow;->e(Ljava/lang/String;Ljava/lang/Object;)V

    .line 143
    .line 144
    .line 145
    invoke-virtual {v2}, Lagow;->b()Lagpb;

    .line 146
    .line 147
    .line 148
    move-result-object v4

    .line 149
    invoke-virtual {p1, v10, v4}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 150
    .line 151
    .line 152
    goto/16 :goto_0

    .line 153
    .line 154
    :cond_4
    and-int/lit8 v2, p1, 0x1

    .line 155
    .line 156
    if-ne v2, v11, :cond_5

    .line 157
    .line 158
    iget-object p1, p0, Lshb;->i:Landroid/util/SparseArray;

    .line 159
    .line 160
    invoke-virtual {p1, v11}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    .line 161
    .line 162
    .line 163
    move-result-object v2

    .line 164
    move-object v4, v2

    .line 165
    check-cast v4, Lagpb;

    .line 166
    .line 167
    if-nez v4, :cond_8

    .line 168
    .line 169
    invoke-direct {p0, v11}, Lshb;->d(Z)Lagow;

    .line 170
    .line 171
    .line 172
    move-result-object v2

    .line 173
    invoke-static {v2, v5}, Latbs;->f(Lagow;Z)V

    .line 174
    .line 175
    .line 176
    invoke-virtual {v2, v6}, Lagow;->k(I)V

    .line 177
    .line 178
    .line 179
    invoke-virtual {v2, v7}, Lagow;->j(I)V

    .line 180
    .line 181
    .line 182
    invoke-static {v8}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 183
    .line 184
    .line 185
    move-result-object v3

    .line 186
    invoke-virtual {v2, v9, v3}, Lagow;->e(Ljava/lang/String;Ljava/lang/Object;)V

    .line 187
    .line 188
    .line 189
    invoke-virtual {v2}, Lagow;->b()Lagpb;

    .line 190
    .line 191
    .line 192
    move-result-object v4

    .line 193
    invoke-virtual {p1, v11, v4}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 194
    .line 195
    .line 196
    goto/16 :goto_0

    .line 197
    .line 198
    :cond_5
    and-int/lit8 v2, p1, 0x4

    .line 199
    .line 200
    const v6, 0x7f1416de

    .line 201
    .line 202
    .line 203
    const/4 v7, 0x4

    .line 204
    if-ne v2, v7, :cond_7

    .line 205
    .line 206
    iget-object p1, p0, Lshb;->i:Landroid/util/SparseArray;

    .line 207
    .line 208
    invoke-virtual {p1, v7}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    .line 209
    .line 210
    .line 211
    move-result-object v2

    .line 212
    check-cast v2, Lagpb;

    .line 213
    .line 214
    if-nez v2, :cond_6

    .line 215
    .line 216
    invoke-direct {p0, v5}, Lshb;->d(Z)Lagow;

    .line 217
    .line 218
    .line 219
    move-result-object v2

    .line 220
    const v8, 0x7f0806eb

    .line 221
    .line 222
    .line 223
    invoke-virtual {v2, v8}, Lagow;->k(I)V

    .line 224
    .line 225
    .line 226
    invoke-virtual {v2, v6}, Lagow;->j(I)V

    .line 227
    .line 228
    .line 229
    const/16 v6, -0x273a

    .line 230
    .line 231
    invoke-virtual {v2, v6, v4}, Lagow;->t(ILjava/lang/Object;)V

    .line 232
    .line 233
    .line 234
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 235
    .line 236
    .line 237
    move-result-object v3

    .line 238
    invoke-virtual {v2, v9, v3}, Lagow;->e(Ljava/lang/String;Ljava/lang/Object;)V

    .line 239
    .line 240
    .line 241
    invoke-virtual {v2}, Lagow;->b()Lagpb;

    .line 242
    .line 243
    .line 244
    move-result-object v4

    .line 245
    invoke-virtual {p1, v7, v4}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 246
    .line 247
    .line 248
    goto :goto_0

    .line 249
    :cond_6
    move-object v4, v2

    .line 250
    goto :goto_0

    .line 251
    :cond_7
    const/4 v2, 0x2

    .line 252
    and-int/2addr p1, v2

    .line 253
    if-ne p1, v2, :cond_8

    .line 254
    .line 255
    iget-object p1, p0, Lshb;->i:Landroid/util/SparseArray;

    .line 256
    .line 257
    invoke-virtual {p1, v2}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    .line 258
    .line 259
    .line 260
    move-result-object v4

    .line 261
    check-cast v4, Lagpb;

    .line 262
    .line 263
    if-nez v4, :cond_8

    .line 264
    .line 265
    invoke-direct {p0, v5}, Lshb;->d(Z)Lagow;

    .line 266
    .line 267
    .line 268
    move-result-object v4

    .line 269
    const v7, 0x7f040194

    .line 270
    .line 271
    .line 272
    invoke-virtual {v4, v7}, Lagow;->k(I)V

    .line 273
    .line 274
    .line 275
    invoke-virtual {v4, v6}, Lagow;->j(I)V

    .line 276
    .line 277
    .line 278
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 279
    .line 280
    .line 281
    move-result-object v3

    .line 282
    invoke-virtual {v4, v9, v3}, Lagow;->e(Ljava/lang/String;Ljava/lang/Object;)V

    .line 283
    .line 284
    .line 285
    invoke-static {v11}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    .line 286
    .line 287
    .line 288
    move-result-object v3

    .line 289
    const-string v6, "disabled"

    .line 290
    .line 291
    invoke-virtual {v4, v6, v3}, Lagow;->e(Ljava/lang/String;Ljava/lang/Object;)V

    .line 292
    .line 293
    .line 294
    const v3, 0x7f1416c5

    .line 295
    .line 296
    .line 297
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 298
    .line 299
    .line 300
    move-result-object v3

    .line 301
    const/16 v6, -0x275b

    .line 302
    .line 303
    invoke-virtual {v4, v6, v3}, Lagow;->t(ILjava/lang/Object;)V

    .line 304
    .line 305
    .line 306
    invoke-virtual {v4}, Lagow;->b()Lagpb;

    .line 307
    .line 308
    .line 309
    move-result-object v4

    .line 310
    invoke-virtual {p1, v2, v4}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 311
    .line 312
    .line 313
    :cond_8
    :goto_0
    if-eqz v4, :cond_a

    .line 314
    .line 315
    filled-new-array {v5}, [I

    .line 316
    .line 317
    .line 318
    move-result-object p0

    .line 319
    invoke-static {}, Lanhs;->b()Lanhs;

    .line 320
    .line 321
    .line 322
    move-result-object p1

    .line 323
    new-instance v2, Lagps;

    .line 324
    .line 325
    invoke-direct {v2, p0, v4, v5}, Lagps;-><init>([ILagpb;Z)V

    .line 326
    .line 327
    .line 328
    invoke-virtual {p1, v2}, Lanhs;->k(Lanhd;)Z

    .line 329
    .line 330
    .line 331
    if-eqz v0, :cond_9

    .line 332
    .line 333
    filled-new-array {v1}, [I

    .line 334
    .line 335
    .line 336
    move-result-object p0

    .line 337
    invoke-static {}, Lanhs;->b()Lanhs;

    .line 338
    .line 339
    .line 340
    move-result-object p1

    .line 341
    new-instance v0, Lagps;

    .line 342
    .line 343
    invoke-direct {v0, p0, v4, v5}, Lagps;-><init>([ILagpb;Z)V

    .line 344
    .line 345
    .line 346
    invoke-virtual {p1, v0}, Lanhs;->k(Lanhd;)Z

    .line 347
    .line 348
    .line 349
    :cond_9
    :goto_1
    return-void

    .line 350
    :cond_a
    invoke-direct {p0}, Lshb;->e()V

    .line 351
    .line 352
    .line 353
    return-void
.end method
