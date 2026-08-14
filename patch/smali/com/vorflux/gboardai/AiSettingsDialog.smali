.class public final Lcom/vorflux/gboardai/AiSettingsDialog;
.super Ljava/lang/Object;
.source "AiSettingsDialog.java"


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 15
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Landroid/content/Context;Landroid/widget/EditText;Landroid/widget/EditText;)Z
    .registers 3

    .line 14
    invoke-static {p0, p1, p2}, Lcom/vorflux/gboardai/AiSettingsDialog;->saveConnection(Landroid/content/Context;Landroid/widget/EditText;Landroid/widget/EditText;)Z

    move-result p0

    return p0
.end method

.method static synthetic access$100(Landroid/content/Context;Landroid/app/AlertDialog;Ljava/util/List;)V
    .registers 3

    .line 14
    invoke-static {p0, p1, p2}, Lcom/vorflux/gboardai/AiSettingsDialog;->showModelPicker(Landroid/content/Context;Landroid/app/AlertDialog;Ljava/util/List;)V

    return-void
.end method

.method private static modeSummary(Landroid/content/Context;)Ljava/lang/String;
    .registers 3

    .line 128
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getManualModel(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    .line 129
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-lez v1, :cond_1e

    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\u5f53\u524d\u6a21\u5f0f\uff1a\u624b\u52a8\n\u5f53\u524d\u6a21\u578b\uff1a"

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 130
    :cond_1e
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\u5f53\u524d\u6a21\u5f0f\uff1a\u81ea\u52a8\n\u5f53\u524d\u6a21\u578b\uff1a"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getCachedModel(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/vorflux/gboardai/AiSettingsDialog;->valueOrNone(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static saveConnection(Landroid/content/Context;Landroid/widget/EditText;Landroid/widget/EditText;)Z
    .registers 4

    .line 86
    invoke-virtual {p2}, Landroid/widget/EditText;->length()I

    move-result v0

    if-lez v0, :cond_f

    invoke-virtual {p2}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p2

    goto :goto_10

    :cond_f
    const/4 p2, 0x0

    .line 87
    :goto_10
    invoke-virtual {p1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/vorflux/gboardai/AiConfig;->setBaseUrl(Landroid/content/Context;Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_25

    .line 88
    const-string p0, "\u8bf7\u8f93\u5165\u6709\u6548\u7684 HTTPS API \u5730\u5740"

    invoke-virtual {p1, p0}, Landroid/widget/EditText;->setError(Ljava/lang/CharSequence;)V

    .line 89
    const/4 p0, 0x0

    return p0

    .line 91
    :cond_25
    if-eqz p2, :cond_2a

    invoke-static {p0, p2}, Lcom/vorflux/gboardai/AiConfig;->setApiKey(Landroid/content/Context;Ljava/lang/String;)V

    .line 92
    :cond_2a
    const/4 p0, 0x1

    return p0
.end method

.method public static show(Landroid/content/Context;)V
    .registers 6

    .line 18
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    iget v0, v0, Landroid/util/DisplayMetrics;->density:F

    const/high16 v1, 0x41a00000    # 20.0f

    mul-float/2addr v0, v1

    invoke-static {v0}, Ljava/lang/Math;->round(F)I

    move-result v0

    .line 19
    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 20
    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 21
    div-int/lit8 v3, v0, 0x2

    const/4 v4, 0x0

    invoke-virtual {v1, v0, v3, v0, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 22
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 23
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "\u6587\u672c\u4f1a\u53d1\u9001\u5230\u60a8\u914d\u7f6e\u7684 OpenAI \u517c\u5bb9\u670d\u52a1\u3002API Key \u7531 Android Keystore \u52a0\u5bc6\u5e76\u4ec5\u4fdd\u5b58\u5728\u672c\u673a\u3002\n\n"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-static {p0}, Lcom/vorflux/gboardai/AiSettingsDialog;->modeSummary(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 24
    invoke-virtual {v1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 25
    new-instance v0, Landroid/widget/EditText;

    invoke-direct {v0, p0}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    .line 26
    const-string v3, "API Base URL"

    invoke-virtual {v0, v3}, Landroid/widget/EditText;->setHint(Ljava/lang/CharSequence;)V

    .line 27
    invoke-virtual {v0, v2}, Landroid/widget/EditText;->setSingleLine(Z)V

    .line 28
    const/16 v3, 0x11

    invoke-virtual {v0, v3}, Landroid/widget/EditText;->setInputType(I)V

    .line 29
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getStoredBaseUrl(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 30
    invoke-virtual {v1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 31
    new-instance v3, Landroid/widget/EditText;

    invoke-direct {v3, p0}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    .line 32
    const-string v4, "API Key\uff08\u7559\u7a7a\u8868\u793a\u4e0d\u4fee\u6539\uff09"

    invoke-virtual {v3, v4}, Landroid/widget/EditText;->setHint(Ljava/lang/CharSequence;)V

    .line 33
    invoke-virtual {v3, v2}, Landroid/widget/EditText;->setSingleLine(Z)V

    .line 34
    const/16 v2, 0x81

    invoke-virtual {v3, v2}, Landroid/widget/EditText;->setInputType(I)V

    .line 35
    invoke-virtual {v1, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 36
    new-instance v2, Landroid/app/AlertDialog$Builder;

    invoke-direct {v2, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    .line 37
    const-string v4, "MyBoard AI \u00b7 OpenAI \u517c\u5bb9\u8bbe\u7f6e"

    invoke-virtual {v2, v4}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v2

    .line 38
    invoke-virtual {v2, v1}, Landroid/app/AlertDialog$Builder;->setView(Landroid/view/View;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    .line 39
    const/high16 v2, 0x1040000

    const/4 v4, 0x0

    invoke-virtual {v1, v2, v4}, Landroid/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    .line 40
    const-string v2, "\u6e05\u9664 Key"

    invoke-virtual {v1, v2, v4}, Landroid/app/AlertDialog$Builder;->setNeutralButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    .line 41
    const-string v2, "\u4fdd\u5b58\u5e76\u9009\u62e9\u6a21\u578b"

    invoke-virtual {v1, v2, v4}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    .line 42
    invoke-virtual {v1}, Landroid/app/AlertDialog$Builder;->create()Landroid/app/AlertDialog;

    move-result-object v1

    .line 43
    new-instance v2, Lcom/vorflux/gboardai/AiSettingsDialog$1;

    invoke-direct {v2, p0, v3, v0}, Lcom/vorflux/gboardai/AiSettingsDialog$1;-><init>(Landroid/content/Context;Landroid/widget/EditText;Landroid/widget/EditText;)V

    invoke-virtual {v1, v2}, Landroid/app/AlertDialog;->setOnShowListener(Landroid/content/DialogInterface$OnShowListener;)V

    .line 82
    invoke-virtual {v1}, Landroid/app/AlertDialog;->show()V

    .line 83
    return-void
.end method

.method private static showModelPicker(Landroid/content/Context;Landroid/app/AlertDialog;Ljava/util/List;)V
    .registers 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Landroid/app/AlertDialog;",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 96
    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result v0

    add-int/lit8 v0, v0, 0x1

    new-array v0, v0, [Ljava/lang/CharSequence;

    .line 97
    const-string v1, "\u81ea\u52a8\u9009\u62e9\uff08\u63a8\u8350\uff09"

    const/4 v2, 0x0

    aput-object v1, v0, v2

    .line 98
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->isManualModel(Landroid/content/Context;)Z

    move-result v1

    if-eqz v1, :cond_15

    const/4 v1, -0x1

    goto :goto_16

    :cond_15
    move v1, v2

    .line 99
    :goto_16
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getManualModel(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v3

    .line 100
    nop

    :goto_1b
    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result v4

    if-ge v2, v4, :cond_3a

    .line 101
    add-int/lit8 v4, v2, 0x1

    invoke-interface {p2, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/CharSequence;

    aput-object v5, v0, v4

    .line 102
    invoke-interface {p2, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_38

    move v1, v4

    .line 100
    :cond_38
    move v2, v4

    goto :goto_1b

    .line 104
    :cond_3a
    if-gez v1, :cond_3f

    const-string v2, "\n\n\u5f53\u524d\u624b\u52a8\u6a21\u578b\u4e0d\u5728\u670d\u52a1\u8fd4\u56de\u7684\u5217\u8868\u4e2d\u3002\u9009\u62e9\u5176\u4ed6\u6a21\u578b\u6216\u81ea\u52a8\u6a21\u5f0f\u540e\u624d\u4f1a\u66f4\u6539\u3002"

    goto :goto_41

    :cond_3f
    const-string v2, ""

    .line 105
    :goto_41
    new-instance v3, Landroid/app/AlertDialog$Builder;

    invoke-direct {v3, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    .line 106
    const-string v4, "\u9009\u62e9\u6a21\u578b"

    invoke-virtual {v3, v4}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "\u6309\u9002\u7528\u6027\u6392\u5e8f\uff1b\u81ea\u52a8\u6a21\u5f0f\u4f1a\u4f7f\u7528\u9996\u9009\u6a21\u578b\uff0c\u5e76\u5728\u6a21\u578b\u5931\u6548\u65f6\u91cd\u65b0\u53d1\u73b0\u3002"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 107
    invoke-virtual {v3, v2}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v2

    new-instance v3, Lcom/vorflux/gboardai/AiSettingsDialog$2;

    invoke-direct {v3, p0, p2, p1}, Lcom/vorflux/gboardai/AiSettingsDialog$2;-><init>(Landroid/content/Context;Ljava/util/List;Landroid/app/AlertDialog;)V

    .line 108
    invoke-virtual {v2, v0, v1, v3}, Landroid/app/AlertDialog$Builder;->setSingleChoiceItems([Ljava/lang/CharSequence;ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    .line 123
    const/high16 p1, 0x1040000

    const/4 p2, 0x0

    invoke-virtual {p0, p1, p2}, Landroid/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    .line 124
    invoke-virtual {p0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 125
    return-void
.end method

.method private static valueOrNone(Ljava/lang/String;)Ljava/lang/String;
    .registers 2

    .line 133
    if-eqz p0, :cond_8

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-nez v0, :cond_a

    :cond_8
    const-string p0, "\u5c1a\u672a\u81ea\u52a8\u83b7\u53d6"

    :cond_a
    return-object p0
.end method
