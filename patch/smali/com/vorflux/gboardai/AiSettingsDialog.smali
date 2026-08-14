.class public final Lcom/vorflux/gboardai/AiSettingsDialog;
.super Ljava/lang/Object;
.source "AiSettingsDialog.java"


# static fields
.field private static final DEBOUNCE_LABELS:[Ljava/lang/String;

.field private static final DEBOUNCE_VALUES:[I

.field private static final STYLE_LABELS:[Ljava/lang/String;

.field private static final STYLE_VALUES:[Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 7

    .line 22
    const-string v4, "professional"

    const-string v5, "custom"

    const-string v0, "standard"

    const-string v1, "concise"

    const-string v2, "formal"

    const-string v3, "natural"

    filled-new-array/range {v0 .. v5}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/vorflux/gboardai/AiSettingsDialog;->STYLE_VALUES:[Ljava/lang/String;

    .line 23
    const-string v5, "\u4e13\u4e1a"

    const-string v6, "\u81ea\u5b9a\u4e49"

    const-string v1, "\u6807\u51c6\u6da6\u8272"

    const-string v2, "\u7b80\u6d01"

    const-string v3, "\u6b63\u5f0f"

    const-string v4, "\u81ea\u7136/\u53e3\u8bed"

    filled-new-array/range {v1 .. v6}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/vorflux/gboardai/AiSettingsDialog;->STYLE_LABELS:[Ljava/lang/String;

    .line 24
    const/16 v0, 0x4b0

    const/16 v1, 0x7d0

    const/16 v2, 0x12c

    const/16 v3, 0x1f4

    const/16 v4, 0x320

    filled-new-array {v2, v3, v4, v0, v1}, [I

    move-result-object v0

    sput-object v0, Lcom/vorflux/gboardai/AiSettingsDialog;->DEBOUNCE_VALUES:[I

    .line 25
    const-string v0, "1200 ms"

    const-string v1, "2000 ms"

    const-string v2, "300 ms"

    const-string v3, "500 ms"

    const-string v4, "800 ms\uff08\u5efa\u8bae\uff09"

    filled-new-array {v2, v3, v4, v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/vorflux/gboardai/AiSettingsDialog;->DEBOUNCE_LABELS:[Ljava/lang/String;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 27
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static button(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/Button;
    .locals 1

    .line 218
    new-instance v0, Landroid/widget/Button;

    invoke-direct {v0, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    .line 219
    invoke-virtual {v0, p1}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 220
    return-object v0
.end method

.method private static indexOf([II)I
    .locals 3

    .line 224
    const/4 v0, 0x0

    move v1, v0

    :goto_2
    array-length v2, p0

    if-ge v1, v2, :cond_d

    aget v2, p0, v1

    if-ne v2, p1, :cond_a

    return v1

    :cond_a
    add-int/lit8 v1, v1, 0x1

    goto :goto_2

    .line 225
    :cond_d
    return v0
.end method

.method private static indexOf([Ljava/lang/String;Ljava/lang/String;)I
    .locals 3

    .line 229
    const/4 v0, 0x0

    move v1, v0

    :goto_2
    array-length v2, p0

    if-ge v1, v2, :cond_11

    aget-object v2, p0, v1

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_e

    return v1

    :cond_e
    add-int/lit8 v1, v1, 0x1

    goto :goto_2

    .line 230
    :cond_11
    return v0
.end method

.method private static input(Landroid/content/Context;Ljava/lang/String;ZI)Landroid/widget/EditText;
    .locals 1

    .line 193
    new-instance v0, Landroid/widget/EditText;

    invoke-direct {v0, p0}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    .line 194
    invoke-virtual {v0, p1}, Landroid/widget/EditText;->setHint(Ljava/lang/CharSequence;)V

    .line 195
    invoke-virtual {v0, p2}, Landroid/widget/EditText;->setSingleLine(Z)V

    .line 196
    invoke-virtual {v0, p3}, Landroid/widget/EditText;->setInputType(I)V

    .line 197
    return-object v0
.end method

.method private static labelled(Landroid/content/Context;Ljava/lang/String;Landroid/view/View;)Landroid/view/View;
    .locals 2

    .line 209
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 210
    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 211
    invoke-static {p0, p1}, Lcom/vorflux/gboardai/AiSettingsDialog;->text(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;

    move-result-object p0

    .line 212
    invoke-virtual {v0, p0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 213
    new-instance p0, Landroid/widget/LinearLayout$LayoutParams;

    const/4 p1, -0x1

    const/4 v1, -0x2

    invoke-direct {p0, p1, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, p2, p0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 214
    return-object v0
.end method

.method static synthetic lambda$show$0(Landroid/widget/EditText;Landroid/view/View;)V
    .locals 0

    .line 55
    const-string p1, "Translate the text from {source} to {target}. Preserve meaning, tone, formatting, line breaks, emoji, names, URLs, numbers, and placeholders. Do not add explanations or invent facts. Return only the translated text."

    invoke-virtual {p0, p1}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method

.method static synthetic lambda$show$1(Landroid/widget/EditText;Landroid/view/View;)V
    .locals 0

    .line 70
    const-string p1, "Polish the user\'s writing in the same language. Improve clarity, fluency, grammar, and naturalness without changing meaning. Preserve formatting, line breaks, emoji, names, URLs, numbers, and placeholders. Return only the polished text."

    invoke-virtual {p0, p1}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method

.method static synthetic lambda$show$2(Landroid/content/Context;Landroid/widget/EditText;Landroid/view/View;)V
    .locals 0

    .line 85
    const-string p2, ""

    invoke-static {p0, p2}, Lcom/vorflux/gboardai/AiConfig;->setApiKey(Landroid/content/Context;Ljava/lang/String;)V

    .line 86
    invoke-virtual {p1, p2}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 87
    const-string p1, "API Key \u5df2\u6e05\u9664"

    const/4 p2, 0x0

    invoke-static {p0, p1, p2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    .line 88
    return-void
.end method

.method static synthetic lambda$show$3(Landroid/widget/Button;Ljava/lang/String;Landroid/content/Context;Landroid/app/AlertDialog;Ljava/util/List;)V
    .locals 1

    .line 113
    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Landroid/widget/Button;->setEnabled(Z)V

    .line 114
    const-string v0, "\u4fdd\u5b58\u5e76\u9009\u62e9\u6a21\u578b"

    invoke-virtual {p0, v0}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 115
    if-eqz p1, :cond_26

    .line 116
    new-instance p0, Landroid/app/AlertDialog$Builder;

    invoke-direct {p0, p2}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string p2, "\u6a21\u578b\u83b7\u53d6\u5931\u8d25"

    invoke-virtual {p0, p2}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    .line 117
    const p1, 0x104000a

    const/4 p2, 0x0

    invoke-virtual {p0, p1, p2}, Landroid/app/AlertDialog$Builder;->setPositiveButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    goto :goto_29

    .line 119
    :cond_26
    invoke-static {p2, p3, p4}, Lcom/vorflux/gboardai/AiSettingsDialog;->showModelPicker(Landroid/content/Context;Landroid/app/AlertDialog;Ljava/util/List;)V

    .line 121
    :goto_29
    return-void
.end method

.method static synthetic lambda$show$4(Landroid/content/Context;Ljava/lang/String;Landroid/app/AlertDialog;Landroid/widget/Button;)V
    .locals 7

    .line 103
    nop

    .line 104
    nop

    .line 106
    const/4 v0, 0x0

    :try_start_3
    invoke-static {p0, p1}, Lcom/vorflux/gboardai/OpenAiClient;->listModels(Landroid/content/Context;Ljava/lang/String;)Ljava/util/List;

    move-result-object p1
    :try_end_7
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_7} :catch_a

    .line 109
    move-object v6, p1

    move-object v3, v0

    goto :goto_11

    .line 107
    :catch_a
    move-exception p1

    .line 108
    invoke-virtual {p1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object p1

    move-object v3, p1

    move-object v6, v0

    .line 110
    :goto_11
    nop

    .line 111
    nop

    .line 112
    invoke-virtual {p2}, Landroid/app/AlertDialog;->getWindow()Landroid/view/Window;

    move-result-object p1

    invoke-virtual {p1}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object p1

    new-instance v0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda4;

    move-object v1, v0

    move-object v2, p3

    move-object v4, p0

    move-object v5, p2

    invoke-direct/range {v1 .. v6}, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda4;-><init>(Landroid/widget/Button;Ljava/lang/String;Landroid/content/Context;Landroid/app/AlertDialog;Ljava/util/List;)V

    invoke-virtual {p1, v0}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    .line 122
    return-void
.end method

.method static synthetic lambda$show$5(Landroid/widget/EditText;Landroid/content/Context;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/Spinner;Landroid/widget/Spinner;Landroid/widget/EditText;Landroid/app/AlertDialog;Landroid/view/View;)V
    .locals 7

    .line 90
    invoke-virtual {p0}, Landroid/widget/EditText;->length()I

    move-result p8

    if-lez p8, :cond_f

    invoke-virtual {p0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p8

    invoke-virtual {p8}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p8

    goto :goto_10

    :cond_f
    const/4 p8, 0x0

    :goto_10
    move-object v2, p8

    .line 91
    move-object v0, p1

    move-object v1, p2

    move-object v3, p3

    move-object v4, p4

    move-object v5, p5

    move-object v6, p6

    invoke-static/range {v0 .. v6}, Lcom/vorflux/gboardai/AiSettingsDialog;->save(Landroid/content/Context;Landroid/widget/EditText;Ljava/lang/String;Landroid/widget/EditText;Landroid/widget/Spinner;Landroid/widget/Spinner;Landroid/widget/EditText;)Z

    move-result p2

    if-nez p2, :cond_1e

    return-void

    .line 92
    :cond_1e
    const/4 p2, -0x1

    invoke-virtual {p7, p2}, Landroid/app/AlertDialog;->getButton(I)Landroid/widget/Button;

    move-result-object p2

    .line 93
    const/4 p3, 0x0

    invoke-virtual {p2, p3}, Landroid/widget/Button;->setEnabled(Z)V

    .line 94
    const-string p3, "\u6b63\u5728\u8bfb\u53d6\u6a21\u578b\u2026"

    invoke-virtual {p2, p3}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 95
    invoke-static {p1}, Lcom/vorflux/gboardai/AiConfig;->getApiKey(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p3

    .line 96
    invoke-static {p3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p4

    if-eqz p4, :cond_45

    .line 97
    const/4 p1, 0x1

    invoke-virtual {p2, p1}, Landroid/widget/Button;->setEnabled(Z)V

    .line 98
    const-string p1, "\u4fdd\u5b58\u5e76\u9009\u62e9\u6a21\u578b"

    invoke-virtual {p2, p1}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 99
    const-string p1, "\u8bf7\u586b\u5199 API Key"

    invoke-virtual {p0, p1}, Landroid/widget/EditText;->setError(Ljava/lang/CharSequence;)V

    .line 100
    return-void

    .line 102
    :cond_45
    new-instance p0, Ljava/lang/Thread;

    new-instance p4, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda1;

    invoke-direct {p4, p1, p3, p7, p2}, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda1;-><init>(Landroid/content/Context;Ljava/lang/String;Landroid/app/AlertDialog;Landroid/widget/Button;)V

    const-string p1, "GboardAI-models"

    invoke-direct {p0, p4, p1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    .line 122
    invoke-virtual {p0}, Ljava/lang/Thread;->start()V

    .line 123
    return-void
.end method

.method static synthetic lambda$show$6(Landroid/app/AlertDialog;Landroid/content/Context;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/Spinner;Landroid/widget/Spinner;Landroid/widget/EditText;Landroid/content/DialogInterface;)V
    .locals 11

    .line 84
    move-object v8, p0

    const/4 v0, -0x3

    invoke-virtual {p0, v0}, Landroid/app/AlertDialog;->getButton(I)Landroid/widget/Button;

    move-result-object v0

    new-instance v1, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda2;

    move-object v2, p1

    move-object v3, p2

    invoke-direct {v1, p1, p2}, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda2;-><init>(Landroid/content/Context;Landroid/widget/EditText;)V

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 89
    const/4 v0, -0x1

    invoke-virtual {p0, v0}, Landroid/app/AlertDialog;->getButton(I)Landroid/widget/Button;

    move-result-object v9

    new-instance v10, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda3;

    move-object v0, v10

    move-object v1, p2

    move-object v3, p3

    move-object v4, p4

    move-object/from16 v5, p5

    move-object/from16 v6, p6

    move-object/from16 v7, p7

    invoke-direct/range {v0 .. v8}, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda3;-><init>(Landroid/widget/EditText;Landroid/content/Context;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/Spinner;Landroid/widget/Spinner;Landroid/widget/EditText;Landroid/app/AlertDialog;)V

    invoke-virtual {v9, v10}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 124
    return-void
.end method

.method static synthetic lambda$showModelPicker$7(Landroid/content/Context;Ljava/util/List;Landroid/app/AlertDialog;Landroid/content/DialogInterface;I)V
    .locals 2

    .line 156
    const/4 v0, 0x0

    if-nez p4, :cond_32

    .line 157
    const-string p4, ""

    invoke-static {p0, p4}, Lcom/vorflux/gboardai/AiConfig;->setManualModel(Landroid/content/Context;Ljava/lang/String;)V

    .line 158
    invoke-interface {p1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p4

    check-cast p4, Ljava/lang/String;

    invoke-static {p0, p4}, Lcom/vorflux/gboardai/AiConfig;->setCachedModel(Landroid/content/Context;Ljava/lang/String;)V

    .line 159
    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\u5df2\u5207\u6362\u4e3a\u81ea\u52a8\u6a21\u5f0f\uff1a"

    invoke-virtual {p4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p4

    invoke-interface {p1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/String;

    invoke-virtual {p4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    goto :goto_57

    .line 161
    :cond_32
    add-int/lit8 p4, p4, -0x1

    invoke-interface {p1, p4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/String;

    .line 162
    invoke-static {p0, p1}, Lcom/vorflux/gboardai/AiConfig;->setManualModel(Landroid/content/Context;Ljava/lang/String;)V

    .line 163
    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\u5df2\u624b\u52a8\u9009\u62e9\u6a21\u578b\uff1a"

    invoke-virtual {p4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p4

    invoke-virtual {p4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    .line 165
    :goto_57
    invoke-interface {p3}, Landroid/content/DialogInterface;->dismiss()V

    .line 166
    invoke-virtual {p2}, Landroid/app/AlertDialog;->dismiss()V

    .line 167
    return-void
.end method

.method private static modeSummary(Landroid/content/Context;)Ljava/lang/String;
    .locals 2

    .line 173
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getManualModel(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    .line 174
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_1e

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

    .line 175
    :cond_1e
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getCachedModel(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    .line 176
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\u5f53\u524d\u6a21\u5f0f\uff1a\u81ea\u52a8\n\u5f53\u524d\u6a21\u578b\uff1a"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_35

    const-string p0, "\u5c1a\u672a\u53d1\u73b0"

    :cond_35
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static save(Landroid/content/Context;Landroid/widget/EditText;Ljava/lang/String;Landroid/widget/EditText;Landroid/widget/Spinner;Landroid/widget/Spinner;Landroid/widget/EditText;)Z
    .locals 1

    .line 130
    invoke-virtual {p1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/vorflux/gboardai/AiConfig;->setBaseUrl(Landroid/content/Context;Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_15

    .line 131
    const-string p0, "\u8bf7\u8f93\u5165\u6709\u6548\u7684 HTTPS API \u5730\u5740"

    invoke-virtual {p1, p0}, Landroid/widget/EditText;->setError(Ljava/lang/CharSequence;)V

    .line 132
    const/4 p0, 0x0

    return p0

    .line 134
    :cond_15
    if-eqz p2, :cond_1a

    invoke-static {p0, p2}, Lcom/vorflux/gboardai/AiConfig;->setApiKey(Landroid/content/Context;Ljava/lang/String;)V

    .line 135
    :cond_1a
    invoke-virtual {p3}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/vorflux/gboardai/AiConfig;->setTranslationPrompt(Landroid/content/Context;Ljava/lang/String;)V

    .line 136
    sget-object p1, Lcom/vorflux/gboardai/AiSettingsDialog;->DEBOUNCE_VALUES:[I

    invoke-virtual {p4}, Landroid/widget/Spinner;->getSelectedItemPosition()I

    move-result p2

    aget p1, p1, p2

    invoke-static {p0, p1}, Lcom/vorflux/gboardai/AiConfig;->setDebounceMs(Landroid/content/Context;I)V

    .line 137
    sget-object p1, Lcom/vorflux/gboardai/AiSettingsDialog;->STYLE_VALUES:[Ljava/lang/String;

    invoke-virtual {p5}, Landroid/widget/Spinner;->getSelectedItemPosition()I

    move-result p2

    aget-object p1, p1, p2

    invoke-static {p0, p1}, Lcom/vorflux/gboardai/AiConfig;->setPolishStyle(Landroid/content/Context;Ljava/lang/String;)V

    .line 138
    invoke-virtual {p6}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/vorflux/gboardai/AiConfig;->setPolishPrompt(Landroid/content/Context;Ljava/lang/String;)V

    .line 139
    const/4 p0, 0x1

    return p0
.end method

.method private static section(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    .locals 2

    .line 186
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\n"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/vorflux/gboardai/AiSettingsDialog;->text(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;

    move-result-object p0

    .line 187
    sget-object p1, Landroid/graphics/Typeface;->DEFAULT:Landroid/graphics/Typeface;

    const/4 v0, 0x1

    invoke-virtual {p0, p1, v0}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;I)V

    .line 188
    const/high16 p1, 0x41880000    # 17.0f

    invoke-virtual {p0, p1}, Landroid/widget/TextView;->setTextSize(F)V

    .line 189
    return-object p0
.end method

.method public static show(Landroid/content/Context;)V
    .locals 14

    .line 30
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    iget v0, v0, Landroid/util/DisplayMetrics;->density:F

    const/high16 v1, 0x41a00000    # 20.0f

    mul-float/2addr v0, v1

    invoke-static {v0}, Ljava/lang/Math;->round(F)I

    move-result v0

    .line 31
    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 32
    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 33
    div-int/lit8 v3, v0, 0x2

    const/4 v4, 0x0

    invoke-virtual {v1, v0, v3, v0, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 35
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u6587\u672c\u4f1a\u53d1\u9001\u5230\u60a8\u914d\u7f6e\u7684 OpenAI \u517c\u5bb9\u670d\u52a1\u3002API Key \u7531 Android Keystore \u52a0\u5bc6\u4e14\u4ec5\u4fdd\u5b58\u5728\u672c\u673a\u3002\u4e0d\u4f1a\u8bb0\u5f55 API Key\u3001\u63d0\u793a\u8bcd\u3001\u539f\u6587\u3001\u8bd1\u6587\u6216\u6da6\u8272\u7ed3\u679c\u3002\n\n"

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {p0}, Lcom/vorflux/gboardai/AiSettingsDialog;->modeSummary(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/vorflux/gboardai/AiSettingsDialog;->text(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;

    move-result-object v0

    .line 36
    invoke-virtual {v1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 38
    const-string v0, "API Base URL"

    const/16 v3, 0x11

    invoke-static {p0, v0, v2, v3}, Lcom/vorflux/gboardai/AiSettingsDialog;->input(Landroid/content/Context;Ljava/lang/String;ZI)Landroid/widget/EditText;

    move-result-object v9

    .line 39
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getStoredBaseUrl(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v9, v0}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 40
    invoke-virtual {v1, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 42
    const-string v0, "API Key\uff08\u7559\u7a7a\u8868\u793a\u4e0d\u4fee\u6539\uff09"

    const/16 v3, 0x81

    invoke-static {p0, v0, v2, v3}, Lcom/vorflux/gboardai/AiSettingsDialog;->input(Landroid/content/Context;Ljava/lang/String;ZI)Landroid/widget/EditText;

    move-result-object v8

    .line 43
    invoke-virtual {v1, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 45
    const-string v0, "\u7ffb\u8bd1"

    invoke-static {p0, v0}, Lcom/vorflux/gboardai/AiSettingsDialog;->section(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;

    move-result-object v0

    invoke-virtual {v1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 46
    sget-object v0, Lcom/vorflux/gboardai/AiSettingsDialog;->DEBOUNCE_LABELS:[Ljava/lang/String;

    invoke-static {p0, v0}, Lcom/vorflux/gboardai/AiSettingsDialog;->spinner(Landroid/content/Context;[Ljava/lang/String;)Landroid/widget/Spinner;

    move-result-object v11

    .line 47
    sget-object v0, Lcom/vorflux/gboardai/AiSettingsDialog;->DEBOUNCE_VALUES:[I

    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getDebounceMs(Landroid/content/Context;)I

    move-result v2

    invoke-static {v0, v2}, Lcom/vorflux/gboardai/AiSettingsDialog;->indexOf([II)I

    move-result v0

    invoke-virtual {v11, v0}, Landroid/widget/Spinner;->setSelection(I)V

    .line 48
    const-string v0, "\u8f93\u5165\u505c\u987f\u65f6\u95f4"

    invoke-static {p0, v0, v11}, Lcom/vorflux/gboardai/AiSettingsDialog;->labelled(Landroid/content/Context;Ljava/lang/String;Landroid/view/View;)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 50
    const-string v0, "\u7ffb\u8bd1\u63d0\u793a\u8bcd\uff1b\u652f\u6301 {source} \u548c {target}"

    const v2, 0x20001

    invoke-static {p0, v0, v4, v2}, Lcom/vorflux/gboardai/AiSettingsDialog;->input(Landroid/content/Context;Ljava/lang/String;ZI)Landroid/widget/EditText;

    move-result-object v10

    .line 51
    const/4 v0, 0x4

    invoke-virtual {v10, v0}, Landroid/widget/EditText;->setMinLines(I)V

    .line 52
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getTranslationPrompt(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v10, v3}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 53
    invoke-virtual {v1, v10}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 54
    const-string v3, "\u6062\u590d\u9ed8\u8ba4\u7ffb\u8bd1\u63d0\u793a\u8bcd"

    invoke-static {p0, v3}, Lcom/vorflux/gboardai/AiSettingsDialog;->button(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/Button;

    move-result-object v3

    .line 55
    new-instance v5, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda5;

    invoke-direct {v5, v10}, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda5;-><init>(Landroid/widget/EditText;)V

    invoke-virtual {v3, v5}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 56
    invoke-virtual {v1, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 58
    const-string v3, "AI \u6da6\u8272"

    invoke-static {p0, v3}, Lcom/vorflux/gboardai/AiSettingsDialog;->section(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 59
    const-string v3, "\u952e\u76d8\u5de5\u5177\u680f\u4e2d\u7684\u201cAI \u6da6\u8272\u201d\u53ef\u76f4\u63a5\u6253\u5f00\u6b64\u529f\u80fd\uff0c\u5e76\u590d\u7528\u539f\u751f\u7ed3\u679c\u3001\u66ff\u6362\u548c\u64a4\u9500\u6d41\u7a0b\u3002"

    invoke-static {p0, v3}, Lcom/vorflux/gboardai/AiSettingsDialog;->text(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;

    move-result-object v3

    .line 60
    invoke-virtual {v1, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 61
    sget-object v3, Lcom/vorflux/gboardai/AiSettingsDialog;->STYLE_LABELS:[Ljava/lang/String;

    invoke-static {p0, v3}, Lcom/vorflux/gboardai/AiSettingsDialog;->spinner(Landroid/content/Context;[Ljava/lang/String;)Landroid/widget/Spinner;

    move-result-object v12

    .line 62
    sget-object v3, Lcom/vorflux/gboardai/AiSettingsDialog;->STYLE_VALUES:[Ljava/lang/String;

    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getPolishStyle(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v5

    invoke-static {v3, v5}, Lcom/vorflux/gboardai/AiSettingsDialog;->indexOf([Ljava/lang/String;Ljava/lang/String;)I

    move-result v3

    invoke-virtual {v12, v3}, Landroid/widget/Spinner;->setSelection(I)V

    .line 63
    const-string v3, "\u9ed8\u8ba4\u98ce\u683c"

    invoke-static {p0, v3, v12}, Lcom/vorflux/gboardai/AiSettingsDialog;->labelled(Landroid/content/Context;Ljava/lang/String;Landroid/view/View;)Landroid/view/View;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 65
    const-string v3, "\u81ea\u5b9a\u4e49\u6da6\u8272\u63d0\u793a\u8bcd"

    invoke-static {p0, v3, v4, v2}, Lcom/vorflux/gboardai/AiSettingsDialog;->input(Landroid/content/Context;Ljava/lang/String;ZI)Landroid/widget/EditText;

    move-result-object v13

    .line 66
    invoke-virtual {v13, v0}, Landroid/widget/EditText;->setMinLines(I)V

    .line 67
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getPolishPrompt(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v13, v0}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 68
    invoke-virtual {v1, v13}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 69
    const-string v0, "\u6062\u590d\u9ed8\u8ba4\u6da6\u8272\u63d0\u793a\u8bcd"

    invoke-static {p0, v0}, Lcom/vorflux/gboardai/AiSettingsDialog;->button(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/Button;

    move-result-object v0

    .line 70
    new-instance v2, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda6;

    invoke-direct {v2, v13}, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda6;-><init>(Landroid/widget/EditText;)V

    invoke-virtual {v0, v2}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 71
    invoke-virtual {v1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 73
    new-instance v0, Landroid/widget/ScrollView;

    invoke-direct {v0, p0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    .line 74
    invoke-virtual {v0, v1}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V

    .line 76
    new-instance v1, Landroid/app/AlertDialog$Builder;

    invoke-direct {v1, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    .line 77
    const-string v2, "MyBoard AI \u00b7 OpenAI \u517c\u5bb9\u8bbe\u7f6e"

    invoke-virtual {v1, v2}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    .line 78
    invoke-virtual {v1, v0}, Landroid/app/AlertDialog$Builder;->setView(Landroid/view/View;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 79
    const/high16 v1, 0x1040000

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 80
    const-string v1, "\u6e05\u9664 Key"

    invoke-virtual {v0, v1, v2}, Landroid/app/AlertDialog$Builder;->setNeutralButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 81
    const-string v1, "\u4fdd\u5b58\u5e76\u9009\u62e9\u6a21\u578b"

    invoke-virtual {v0, v1, v2}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 82
    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->create()Landroid/app/AlertDialog;

    move-result-object v0

    .line 83
    new-instance v1, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda7;

    move-object v5, v1

    move-object v6, v0

    move-object v7, p0

    invoke-direct/range {v5 .. v13}, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda7;-><init>(Landroid/app/AlertDialog;Landroid/content/Context;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/Spinner;Landroid/widget/Spinner;Landroid/widget/EditText;)V

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog;->setOnShowListener(Landroid/content/DialogInterface$OnShowListener;)V

    .line 125
    invoke-virtual {v0}, Landroid/app/AlertDialog;->show()V

    .line 126
    return-void
.end method

.method private static showModelPicker(Landroid/content/Context;Landroid/app/AlertDialog;Ljava/util/List;)V
    .locals 6
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

    .line 143
    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result v0

    add-int/lit8 v0, v0, 0x1

    new-array v0, v0, [Ljava/lang/CharSequence;

    .line 144
    const-string v1, "\u81ea\u52a8\u9009\u62e9\uff08\u63a8\u8350\uff09"

    const/4 v2, 0x0

    aput-object v1, v0, v2

    .line 145
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->isManualModel(Landroid/content/Context;)Z

    move-result v1

    if-eqz v1, :cond_15

    const/4 v1, -0x1

    goto :goto_16

    :cond_15
    move v1, v2

    .line 146
    :goto_16
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getManualModel(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v3

    .line 147
    nop

    :goto_1b
    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result v4

    if-ge v2, v4, :cond_3a

    .line 148
    add-int/lit8 v4, v2, 0x1

    invoke-interface {p2, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/CharSequence;

    aput-object v5, v0, v4

    .line 149
    invoke-interface {p2, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_38

    move v1, v4

    .line 147
    :cond_38
    move v2, v4

    goto :goto_1b

    .line 151
    :cond_3a
    if-gez v1, :cond_3f

    const-string v2, "\u9009\u62e9\u6a21\u578b\uff08\u5f53\u524d\u624b\u52a8\u6a21\u578b\u5df2\u5931\u6548\uff09"

    goto :goto_41

    :cond_3f
    const-string v2, "\u9009\u62e9\u6a21\u578b"

    .line 152
    :goto_41
    new-instance v3, Landroid/app/AlertDialog$Builder;

    invoke-direct {v3, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    .line 153
    invoke-virtual {v3, v2}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v2

    new-instance v3, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda0;

    invoke-direct {v3, p0, p2, p1}, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda0;-><init>(Landroid/content/Context;Ljava/util/List;Landroid/app/AlertDialog;)V

    .line 154
    invoke-virtual {v2, v0, v1, v3}, Landroid/app/AlertDialog$Builder;->setSingleChoiceItems([Ljava/lang/CharSequence;ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    .line 167
    const/high16 p1, 0x1040000

    const/4 p2, 0x0

    invoke-virtual {p0, p1, p2}, Landroid/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    .line 168
    invoke-virtual {p0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 169
    return-void
.end method

.method private static spinner(Landroid/content/Context;[Ljava/lang/String;)Landroid/widget/Spinner;
    .locals 3

    .line 201
    new-instance v0, Landroid/widget/Spinner;

    invoke-direct {v0, p0}, Landroid/widget/Spinner;-><init>(Landroid/content/Context;)V

    .line 202
    new-instance v1, Landroid/widget/ArrayAdapter;

    const v2, 0x1090008

    invoke-direct {v1, p0, v2, p1}, Landroid/widget/ArrayAdapter;-><init>(Landroid/content/Context;I[Ljava/lang/Object;)V

    .line 203
    const p0, 0x1090009

    invoke-virtual {v1, p0}, Landroid/widget/ArrayAdapter;->setDropDownViewResource(I)V

    .line 204
    invoke-virtual {v0, v1}, Landroid/widget/Spinner;->setAdapter(Landroid/widget/SpinnerAdapter;)V

    .line 205
    return-object v0
.end method

.method private static text(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    .locals 1

    .line 180
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 181
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 182
    return-object v0
.end method
