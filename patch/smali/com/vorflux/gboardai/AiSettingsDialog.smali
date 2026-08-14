.class public final Lcom/vorflux/gboardai/AiSettingsDialog;
.super Ljava/lang/Object;
.source "AiSettingsDialog.java"


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 14
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static show(Landroid/content/Context;)V
    .registers 6

    .line 17
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    iget v0, v0, Landroid/util/DisplayMetrics;->density:F

    const/high16 v1, 0x41a00000    # 20.0f

    mul-float/2addr v0, v1

    invoke-static {v0}, Ljava/lang/Math;->round(F)I

    move-result v0

    .line 18
    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 19
    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 20
    div-int/lit8 v3, v0, 0x2

    const/4 v4, 0x0

    invoke-virtual {v1, v0, v3, v0, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 21
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 22
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "\u6587\u672c\u4f1a\u53d1\u9001\u5230\u60a8\u914d\u7f6e\u7684 OpenAI \u517c\u5bb9\u670d\u52a1\u3002\u6a21\u578b\u901a\u8fc7 /v1/models \u81ea\u52a8\u83b7\u53d6\uff1bAPI Key \u7531 Android Keystore \u52a0\u5bc6\u5e76\u4ec5\u4fdd\u5b58\u5728\u672c\u673a\u3002\n\n\u73b0\u6709 AI \u6a21\u578b\uff1a"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getCachedModel(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/vorflux/gboardai/AiSettingsDialog;->valueOrNone(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 23
    invoke-virtual {v1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 24
    new-instance v0, Landroid/widget/EditText;

    invoke-direct {v0, p0}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    .line 25
    const-string v3, "API Base URL"

    invoke-virtual {v0, v3}, Landroid/widget/EditText;->setHint(Ljava/lang/CharSequence;)V

    .line 26
    invoke-virtual {v0, v2}, Landroid/widget/EditText;->setSingleLine(Z)V

    .line 27
    const/16 v3, 0x11

    invoke-virtual {v0, v3}, Landroid/widget/EditText;->setInputType(I)V

    .line 28
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getStoredBaseUrl(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 29
    invoke-virtual {v1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 30
    new-instance v3, Landroid/widget/EditText;

    invoke-direct {v3, p0}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    .line 31
    const-string v4, "API Key\uff08\u7559\u7a7a\u8868\u793a\u4e0d\u4fee\u6539\uff09"

    invoke-virtual {v3, v4}, Landroid/widget/EditText;->setHint(Ljava/lang/CharSequence;)V

    .line 32
    invoke-virtual {v3, v2}, Landroid/widget/EditText;->setSingleLine(Z)V

    .line 33
    const/16 v2, 0x81

    invoke-virtual {v3, v2}, Landroid/widget/EditText;->setInputType(I)V

    .line 34
    invoke-virtual {v1, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 35
    new-instance v2, Landroid/app/AlertDialog$Builder;

    invoke-direct {v2, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    .line 36
    const-string v4, "Gboard AI \u00b7 OpenAI \u517c\u5bb9\u8bbe\u7f6e"

    invoke-virtual {v2, v4}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v2

    .line 37
    invoke-virtual {v2, v1}, Landroid/app/AlertDialog$Builder;->setView(Landroid/view/View;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    .line 38
    const/high16 v2, 0x1040000

    const/4 v4, 0x0

    invoke-virtual {v1, v2, v4}, Landroid/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    .line 39
    const-string v2, "\u6e05\u9664 Key"

    invoke-virtual {v1, v2, v4}, Landroid/app/AlertDialog$Builder;->setNeutralButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    .line 40
    const-string v2, "\u4fdd\u5b58\u5e76\u83b7\u53d6\u6a21\u578b"

    invoke-virtual {v1, v2, v4}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    .line 41
    invoke-virtual {v1}, Landroid/app/AlertDialog$Builder;->create()Landroid/app/AlertDialog;

    move-result-object v1

    .line 42
    new-instance v2, Lcom/vorflux/gboardai/AiSettingsDialog$1;

    invoke-direct {v2, p0, v3, v0}, Lcom/vorflux/gboardai/AiSettingsDialog$1;-><init>(Landroid/content/Context;Landroid/widget/EditText;Landroid/widget/EditText;)V

    invoke-virtual {v1, v2}, Landroid/app/AlertDialog;->setOnShowListener(Landroid/content/DialogInterface$OnShowListener;)V

    .line 86
    invoke-virtual {v1}, Landroid/app/AlertDialog;->show()V

    .line 87
    return-void
.end method

.method private static valueOrNone(Ljava/lang/String;)Ljava/lang/String;
    .registers 2

    .line 89
    if-eqz p0, :cond_8

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-nez v0, :cond_a

    :cond_8
    const-string p0, "\u672a\u83b7\u53d6"

    :cond_a
    return-object p0
.end method
