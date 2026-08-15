.class public final Lcom/vorflux/gboardai/AiConfig;
.super Ljava/lang/Object;
.source "AiConfig.java"


# static fields
.field private static final DEFAULT_BASE:Ljava/lang/String; = "https://api.openai.com/v1"

.field public static final DEFAULT_POLISH_PROMPT:Ljava/lang/String; = "Polish the user\'s writing in the same language. Improve clarity, fluency, grammar, and naturalness without changing meaning. Preserve formatting, line breaks, emoji, names, URLs, numbers, and placeholders. Return only the polished text."

.field public static final DEFAULT_TRANSLATION_PROMPT:Ljava/lang/String; = "Translate the text from {source} to {target}. Preserve meaning, tone, formatting, line breaks, emoji, names, URLs, numbers, and placeholders. Do not add explanations or invent facts. Return only the translated text."

.field private static final KEY_ALIAS:Ljava/lang/String; = "gboard_ai_openai_key"

.field private static final PREFS:Ljava/lang/String; = "gboard_ai_private"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 26
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static endpointKey(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 96
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getStoredBaseUrl(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->normalizeBaseUrl(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 97
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_11

    const-string p0, ""

    goto :goto_22

    :cond_11
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    :goto_22
    return-object p0
.end method

.method public static formatTranslationPrompt(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 138
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getTranslationPrompt(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    .line 139
    if-nez p1, :cond_8

    const-string p1, "auto"

    :cond_8
    const-string v0, "{source}"

    invoke-virtual {p0, v0, p1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    .line 140
    if-nez p2, :cond_12

    const-string p2, ""

    :cond_12
    const-string p1, "{target}"

    invoke-virtual {p0, p1, p2}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    .line 138
    return-object p0
.end method

.method public static getApiKey(Landroid/content/Context;)Ljava/lang/String;
    .locals 7

    .line 66
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "api_key"

    const-string v1, ""

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 67
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_13

    return-object v1

    .line 69
    :cond_13
    :try_start_13
    const-string v0, "\\."

    const/4 v2, 0x2

    invoke-virtual {p0, v0, v2}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object p0

    .line 70
    array-length v0, p0

    if-eq v0, v2, :cond_1e

    return-object v1

    .line 71
    :cond_1e
    const-string v0, "AES/GCM/NoPadding"

    invoke-static {v0}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;

    move-result-object v0

    .line 72
    invoke-static {}, Lcom/vorflux/gboardai/AiConfig;->getOrCreateKey()Ljavax/crypto/SecretKey;

    move-result-object v3

    new-instance v4, Ljavax/crypto/spec/GCMParameterSpec;

    const/4 v5, 0x0

    aget-object v5, p0, v5

    invoke-static {v5, v2}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object v5

    const/16 v6, 0x80

    invoke-direct {v4, v6, v5}, Ljavax/crypto/spec/GCMParameterSpec;-><init>(I[B)V

    invoke-virtual {v0, v2, v3, v4}, Ljavax/crypto/Cipher;->init(ILjava/security/Key;Ljava/security/spec/AlgorithmParameterSpec;)V

    .line 73
    new-instance v3, Ljava/lang/String;

    const/4 v4, 0x1

    aget-object p0, p0, v4

    invoke-static {p0, v2}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object p0

    invoke-virtual {v0, p0}, Ljavax/crypto/Cipher;->doFinal([B)[B

    move-result-object p0

    sget-object v0, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v3, p0, v0}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V
    :try_end_4b
    .catch Ljava/lang/Exception; {:try_start_13 .. :try_end_4b} :catch_4c

    return-object v3

    .line 74
    :catch_4c
    move-exception p0

    .line 75
    return-object v1
.end method

.method public static getBaseUrl(Landroid/content/Context;)Ljava/lang/String;
    .locals 1

    .line 53
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getStoredBaseUrl(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->normalizeBaseUrl(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 54
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_f

    .line 55
    return-object p0

    .line 54
    :cond_f
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string v0, "API \u5730\u5740\u65e0\u6548\uff0c\u8bf7\u5728 MyBoard \u8bbe\u7f6e\u4e2d\u586b\u5199\u6709\u6548\u7684 HTTPS \u5730\u5740"

    invoke-direct {p0, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static getCachedModel(Landroid/content/Context;)Ljava/lang/String;
    .locals 3

    .line 101
    const-string v0, "model_"

    invoke-static {p0, v0}, Lcom/vorflux/gboardai/AiConfig;->endpointKey(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 102
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    const-string v2, ""

    if-eqz v1, :cond_f

    return-object v2

    .line 103
    :cond_f
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0, v0, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 104
    if-nez p0, :cond_1a

    goto :goto_1b

    :cond_1a
    move-object v2, p0

    :goto_1b
    return-object v2
.end method

.method public static getDebounceMs(Landroid/content/Context;)I
    .locals 2

    .line 164
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "translation_debounce_ms"

    const/16 v1, 0x320

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p0

    .line 165
    sparse-switch p0, :sswitch_data_12

    .line 173
    return v1

    .line 171
    :sswitch_10
    return p0

    nop

    :sswitch_data_12
    .sparse-switch
        0x12c -> :sswitch_10
        0x1f4 -> :sswitch_10
        0x320 -> :sswitch_10
        0x4b0 -> :sswitch_10
        0x7d0 -> :sswitch_10
    .end sparse-switch
.end method

.method public static getManualModel(Landroid/content/Context;)Ljava/lang/String;
    .locals 3

    .line 112
    const-string v0, "manual_model_"

    invoke-static {p0, v0}, Lcom/vorflux/gboardai/AiConfig;->endpointKey(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 113
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    const-string v2, ""

    if-eqz v1, :cond_f

    return-object v2

    .line 114
    :cond_f
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0, v0, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 115
    if-nez p0, :cond_1a

    goto :goto_1b

    :cond_1a
    move-object v2, p0

    :goto_1b
    return-object v2
.end method

.method private static getOrCreateKey()Ljavax/crypto/SecretKey;
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 192
    const-string v0, "AndroidKeyStore"

    invoke-static {v0}, Ljava/security/KeyStore;->getInstance(Ljava/lang/String;)Ljava/security/KeyStore;

    move-result-object v1

    .line 193
    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Ljava/security/KeyStore;->load(Ljava/security/KeyStore$LoadStoreParameter;)V

    .line 194
    const-string v3, "gboard_ai_openai_key"

    invoke-virtual {v1, v3}, Ljava/security/KeyStore;->containsAlias(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_47

    .line 195
    const-string v4, "AES"

    invoke-static {v4, v0}, Ljavax/crypto/KeyGenerator;->getInstance(Ljava/lang/String;Ljava/lang/String;)Ljavax/crypto/KeyGenerator;

    move-result-object v0

    .line 196
    new-instance v4, Landroid/security/keystore/KeyGenParameterSpec$Builder;

    const/4 v5, 0x3

    invoke-direct {v4, v3, v5}, Landroid/security/keystore/KeyGenParameterSpec$Builder;-><init>(Ljava/lang/String;I)V

    .line 198
    const/16 v5, 0x100

    invoke-virtual {v4, v5}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setKeySize(I)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object v4

    const-string v5, "GCM"

    filled-new-array {v5}, [Ljava/lang/String;

    move-result-object v5

    .line 199
    invoke-virtual {v4, v5}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setBlockModes([Ljava/lang/String;)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object v4

    const-string v5, "NoPadding"

    filled-new-array {v5}, [Ljava/lang/String;

    move-result-object v5

    .line 200
    invoke-virtual {v4, v5}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setEncryptionPaddings([Ljava/lang/String;)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object v4

    .line 201
    const/4 v5, 0x1

    invoke-virtual {v4, v5}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->setRandomizedEncryptionRequired(Z)Landroid/security/keystore/KeyGenParameterSpec$Builder;

    move-result-object v4

    .line 202
    invoke-virtual {v4}, Landroid/security/keystore/KeyGenParameterSpec$Builder;->build()Landroid/security/keystore/KeyGenParameterSpec;

    move-result-object v4

    .line 196
    invoke-virtual {v0, v4}, Ljavax/crypto/KeyGenerator;->init(Ljava/security/spec/AlgorithmParameterSpec;)V

    .line 203
    invoke-virtual {v0}, Ljavax/crypto/KeyGenerator;->generateKey()Ljavax/crypto/SecretKey;

    .line 205
    :cond_47
    invoke-virtual {v1, v3, v2}, Ljava/security/KeyStore;->getEntry(Ljava/lang/String;Ljava/security/KeyStore$ProtectionParameter;)Ljava/security/KeyStore$Entry;

    move-result-object v0

    check-cast v0, Ljava/security/KeyStore$SecretKeyEntry;

    invoke-virtual {v0}, Ljava/security/KeyStore$SecretKeyEntry;->getSecretKey()Ljavax/crypto/SecretKey;

    move-result-object v0

    return-object v0
.end method

.method public static getPolishPrompt(Landroid/content/Context;)Ljava/lang/String;
    .locals 2

    .line 144
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "polish_prompt"

    const-string v1, "Polish the user\'s writing in the same language. Improve clarity, fluency, grammar, and naturalness without changing meaning. Preserve formatting, line breaks, emoji, names, URLs, numbers, and placeholders. Return only the polished text."

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 145
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_13

    goto :goto_14

    :cond_13
    move-object v1, p0

    :goto_14
    return-object v1
.end method

.method public static getPolishStyle(Landroid/content/Context;)Ljava/lang/String;
    .locals 2

    .line 154
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "polish_style"

    const-string v1, "standard"

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 155
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_13

    goto :goto_14

    :cond_13
    move-object v1, p0

    :goto_14
    return-object v1
.end method

.method public static getStoredBaseUrl(Landroid/content/Context;)Ljava/lang/String;
    .locals 2

    .line 48
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "base_url"

    const-string v1, "https://api.openai.com/v1"

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 49
    if-nez p0, :cond_f

    goto :goto_10

    :cond_f
    move-object v1, p0

    :goto_10
    return-object v1
.end method

.method public static getTranslationPrompt(Landroid/content/Context;)Ljava/lang/String;
    .locals 2

    .line 128
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "translation_prompt"

    const-string v1, "Translate the text from {source} to {target}. Preserve meaning, tone, formatting, line breaks, emoji, names, URLs, numbers, and placeholders. Do not add explanations or invent facts. Return only the translated text."

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 129
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_13

    goto :goto_14

    :cond_13
    move-object v1, p0

    :goto_14
    return-object v1
.end method

.method public static isManualModel(Landroid/content/Context;)Z
    .locals 0

    .line 119
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getManualModel(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0
.end method

.method public static normalizeBaseUrl(Ljava/lang/String;)Ljava/lang/String;
    .locals 4

    .line 33
    const-string v0, ""

    if-nez p0, :cond_5

    return-object v0

    .line 34
    :cond_5
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    .line 35
    :goto_9
    const-string v1, "/"

    invoke-virtual {p0, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1d

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    add-int/lit8 v1, v1, -0x1

    const/4 v2, 0x0

    invoke-virtual {p0, v2, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    goto :goto_9

    .line 37
    :cond_1d
    :try_start_1d
    new-instance v1, Ljava/net/URL;

    invoke-direct {v1, p0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    .line 38
    const-string v2, "https"

    invoke-virtual {v1}, Ljava/net/URL;->getProtocol()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_66

    invoke-virtual {v1}, Ljava/net/URL;->getHost()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_66

    .line 39
    invoke-virtual {v1}, Ljava/net/URL;->getUserInfo()Ljava/lang/String;

    move-result-object v2

    if-nez v2, :cond_66

    invoke-virtual {v1}, Ljava/net/URL;->getQuery()Ljava/lang/String;

    move-result-object v2

    if-nez v2, :cond_66

    invoke-virtual {v1}, Ljava/net/URL;->getRef()Ljava/lang/String;

    move-result-object v1
    :try_end_48
    .catch Ljava/lang/Exception; {:try_start_1d .. :try_end_48} :catch_67

    if-eqz v1, :cond_4b

    goto :goto_66

    .line 42
    :cond_4b
    nop

    .line 43
    const-string v0, "/v1"

    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_65

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 44
    :cond_65
    return-object p0

    .line 39
    :cond_66
    :goto_66
    return-object v0

    .line 40
    :catch_67
    move-exception p0

    .line 41
    return-object v0
.end method

.method private static prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 2

    .line 29
    const-string v0, "gboard_ai_private"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method public static setApiKey(Landroid/content/Context;Ljava/lang/String;)V
    .locals 5

    .line 80
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    const-string v1, "api_key"

    if-eqz v0, :cond_18

    .line 81
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 82
    return-void

    .line 85
    :cond_18
    :try_start_18
    const-string v0, "AES/GCM/NoPadding"

    invoke-static {v0}, Ljavax/crypto/Cipher;->getInstance(Ljava/lang/String;)Ljavax/crypto/Cipher;

    move-result-object v0

    .line 86
    invoke-static {}, Lcom/vorflux/gboardai/AiConfig;->getOrCreateKey()Ljavax/crypto/SecretKey;

    move-result-object v2

    const/4 v3, 0x1

    invoke-virtual {v0, v3, v2}, Ljavax/crypto/Cipher;->init(ILjava/security/Key;)V

    .line 87
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0}, Ljavax/crypto/Cipher;->getIV()[B

    move-result-object v3

    const/4 v4, 0x2

    invoke-static {v3, v4}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "."

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 88
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    sget-object v3, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p1, v3}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p1

    invoke-virtual {v0, p1}, Ljavax/crypto/Cipher;->doFinal([B)[B

    move-result-object p1

    invoke-static {p1, v4}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 89
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V
    :try_end_67
    .catch Ljava/lang/Exception; {:try_start_18 .. :try_end_67} :catch_68

    .line 92
    goto :goto_78

    .line 90
    :catch_68
    move-exception p1

    .line 91
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 93
    :goto_78
    return-void
.end method

.method public static setBaseUrl(Landroid/content/Context;Ljava/lang/String;)Z
    .locals 1

    .line 59
    invoke-static {p1}, Lcom/vorflux/gboardai/AiConfig;->normalizeBaseUrl(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 60
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_c

    const/4 p0, 0x0

    return p0

    .line 61
    :cond_c
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "base_url"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 62
    const/4 p0, 0x1

    return p0
.end method

.method public static setCachedModel(Landroid/content/Context;Ljava/lang/String;)V
    .locals 3

    .line 108
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "model_"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getBaseUrl(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    if-nez p1, :cond_23

    const-string p1, ""

    :cond_23
    invoke-interface {v0, p0, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 109
    return-void
.end method

.method public static setDebounceMs(Landroid/content/Context;I)V
    .locals 1

    .line 178
    const-string v0, "translation_debounce_ms"

    sparse-switch p1, :sswitch_data_28

    .line 187
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const/16 p1, 0x320

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    goto :goto_27

    .line 184
    :sswitch_17
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 185
    nop

    .line 189
    :goto_27
    return-void

    :sswitch_data_28
    .sparse-switch
        0x12c -> :sswitch_17
        0x1f4 -> :sswitch_17
        0x320 -> :sswitch_17
        0x4b0 -> :sswitch_17
        0x7d0 -> :sswitch_17
    .end sparse-switch
.end method

.method public static setManualModel(Landroid/content/Context;Ljava/lang/String;)V
    .locals 2

    .line 123
    if-nez p1, :cond_5

    const-string p1, ""

    goto :goto_9

    :cond_5
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    .line 124
    :goto_9
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "manual_model_"

    invoke-static {p0, v1}, Lcom/vorflux/gboardai/AiConfig;->endpointKey(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-interface {v0, p0, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 125
    return-void
.end method

.method public static setPolishPrompt(Landroid/content/Context;Ljava/lang/String;)V
    .locals 1

    .line 149
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 150
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_11

    const-string p1, "Polish the user\'s writing in the same language. Improve clarity, fluency, grammar, and naturalness without changing meaning. Preserve formatting, line breaks, emoji, names, URLs, numbers, and placeholders. Return only the polished text."

    goto :goto_15

    :cond_11
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    .line 149
    :goto_15
    const-string v0, "polish_prompt"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 150
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 151
    return-void
.end method

.method public static setPolishStyle(Landroid/content/Context;Ljava/lang/String;)V
    .locals 1

    .line 159
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 160
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_10

    const-string p1, "standard"

    .line 159
    :cond_10
    const-string v0, "polish_style"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 160
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 161
    return-void
.end method

.method public static setTranslationPrompt(Landroid/content/Context;Ljava/lang/String;)V
    .locals 1

    .line 133
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 134
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_11

    const-string p1, "Translate the text from {source} to {target}. Preserve meaning, tone, formatting, line breaks, emoji, names, URLs, numbers, and placeholders. Do not add explanations or invent facts. Return only the translated text."

    goto :goto_15

    :cond_11
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    .line 133
    :goto_15
    const-string v0, "translation_prompt"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 134
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 135
    return-void
.end method
