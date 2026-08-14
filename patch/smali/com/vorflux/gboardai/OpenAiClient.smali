.class public final Lcom/vorflux/gboardai/OpenAiClient;
.super Ljava/lang/Object;
.source "OpenAiClient.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/vorflux/gboardai/OpenAiClient$Callback;,
        Lcom/vorflux/gboardai/OpenAiClient$HttpStatusException;
    }
.end annotation


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 20
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Ljava/lang/Exception;)Ljava/lang/String;
    .registers 1

    .line 19
    invoke-static {p0}, Lcom/vorflux/gboardai/OpenAiClient;->safeError(Ljava/lang/Exception;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$100(Ljava/lang/String;)I
    .registers 1

    .line 19
    invoke-static {p0}, Lcom/vorflux/gboardai/OpenAiClient;->score(Ljava/lang/String;)I

    move-result p0

    return p0
.end method

.method public static complete(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 16
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 52
    const-string v0, ""

    const-string v1, "/chat/completions"

    const-string v2, "POST"

    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getApiKey(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v3

    .line 53
    invoke-static {v3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v4

    if-nez v4, :cond_ee

    .line 54
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->isManualModel(Landroid/content/Context;)Z

    move-result v4

    .line 55
    if-eqz v4, :cond_1b

    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getManualModel(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v5

    goto :goto_1f

    :cond_1b
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getCachedModel(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v5

    .line 56
    :goto_1f
    invoke-static {v5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v6

    if-eqz v6, :cond_2c

    .line 57
    invoke-static {p0, v3}, Lcom/vorflux/gboardai/OpenAiClient;->discoverModel(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 58
    invoke-static {p0, v5}, Lcom/vorflux/gboardai/AiConfig;->setCachedModel(Landroid/content/Context;Ljava/lang/String;)V

    .line 60
    :cond_2c
    new-instance v6, Lorg/json/JSONObject;

    invoke-direct {v6}, Lorg/json/JSONObject;-><init>()V

    .line 61
    const-string v7, "model"

    invoke-virtual {v6, v7, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 62
    const-string v8, "temperature"

    const-wide v9, 0x3fc999999999999aL    # 0.2

    invoke-virtual {v6, v8, v9, v10}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    .line 63
    const-string v8, "stream"

    const/4 v9, 0x0

    invoke-virtual {v6, v8, v9}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    .line 64
    new-instance v8, Lorg/json/JSONArray;

    invoke-direct {v8}, Lorg/json/JSONArray;-><init>()V

    .line 65
    new-instance v10, Lorg/json/JSONObject;

    invoke-direct {v10}, Lorg/json/JSONObject;-><init>()V

    const-string v11, "system"

    const-string v12, "role"

    invoke-virtual {v10, v12, v11}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v10

    const-string v11, "content"

    invoke-virtual {v10, v11, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p1

    invoke-virtual {v8, p1}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    .line 66
    new-instance p1, Lorg/json/JSONObject;

    invoke-direct {p1}, Lorg/json/JSONObject;-><init>()V

    const-string v10, "user"

    invoke-virtual {p1, v12, v10}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p1

    invoke-virtual {p1, v11, p2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p1

    invoke-virtual {v8, p1}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    .line 67
    const-string p1, "messages"

    invoke-virtual {v6, p1, v8}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 70
    :try_start_78
    invoke-static {p0, v2, v1, v3, v6}, Lcom/vorflux/gboardai/OpenAiClient;->request(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lorg/json/JSONObject;)Lorg/json/JSONObject;

    move-result-object p0
    :try_end_7c
    .catch Lcom/vorflux/gboardai/OpenAiClient$HttpStatusException; {:try_start_78 .. :try_end_7c} :catch_7d

    .line 81
    goto :goto_97

    .line 71
    :catch_7d
    move-exception p1

    .line 72
    invoke-virtual {p1}, Lcom/vorflux/gboardai/OpenAiClient$HttpStatusException;->isMissingModel()Z

    move-result p2

    if-eqz p2, :cond_ed

    .line 73
    if-nez v4, :cond_ce

    .line 76
    invoke-static {p0, v0}, Lcom/vorflux/gboardai/AiConfig;->setCachedModel(Landroid/content/Context;Ljava/lang/String;)V

    .line 77
    invoke-static {p0, v3}, Lcom/vorflux/gboardai/OpenAiClient;->discoverModel(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 78
    invoke-static {p0, p1}, Lcom/vorflux/gboardai/AiConfig;->setCachedModel(Landroid/content/Context;Ljava/lang/String;)V

    .line 79
    invoke-virtual {v6, v7, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 80
    invoke-static {p0, v2, v1, v3, v6}, Lcom/vorflux/gboardai/OpenAiClient;->request(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lorg/json/JSONObject;)Lorg/json/JSONObject;

    move-result-object p0

    .line 82
    :goto_97
    const-string p1, "choices"

    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object p0

    .line 83
    if-eqz p0, :cond_c6

    invoke-virtual {p0}, Lorg/json/JSONArray;->length()I

    move-result p1

    if-eqz p1, :cond_c6

    .line 84
    invoke-virtual {p0, v9}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object p0

    const-string p1, "message"

    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object p0

    invoke-virtual {p0, v11, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 85
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p1

    if-nez p1, :cond_be

    .line 86
    return-object p0

    .line 85
    :cond_be
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "\u6a21\u578b\u8fd4\u56de\u4e86\u7a7a\u5185\u5bb9"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 83
    :cond_c6
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "\u6a21\u578b\u672a\u8fd4\u56de\u5185\u5bb9"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 74
    :cond_ce
    new-instance p0, Ljava/lang/IllegalStateException;

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "\u624b\u52a8\u9009\u62e9\u7684\u6a21\u578b\u201c"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, "\u201d\u4e0d\u53ef\u7528\u3002\u8bf7\u5728 MyBoard AI \u8bbe\u7f6e\u4e2d\u9009\u62e9\u5176\u4ed6\u6a21\u578b\u6216\u5207\u56de\u81ea\u52a8\u6a21\u5f0f\u3002"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 72
    :cond_ed
    throw p1

    .line 53
    :cond_ee
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "\u8bf7\u5148\u5728 Gboard \u8bbe\u7f6e\u4e2d\u914d\u7f6e OpenAI API Key"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static completeAsync(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Lcom/vorflux/gboardai/OpenAiClient$Callback;)V
    .registers 6

    .line 36
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/vorflux/gboardai/OpenAiClient$1;

    invoke-direct {v1, p0, p1, p2, p3}, Lcom/vorflux/gboardai/OpenAiClient$1;-><init>(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Lcom/vorflux/gboardai/OpenAiClient$Callback;)V

    const-string p0, "GboardAI"

    invoke-direct {v0, v1, p0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    .line 48
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    .line 49
    return-void
.end method

.method public static discoverModel(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    .registers 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 115
    invoke-static {p0, p1}, Lcom/vorflux/gboardai/OpenAiClient;->listModels(Landroid/content/Context;Ljava/lang/String;)Ljava/util/List;

    move-result-object p0

    const/4 p1, 0x0

    invoke-interface {p0, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    return-object p0
.end method

.method public static listModels(Landroid/content/Context;Ljava/lang/String;)Ljava/util/List;
    .registers 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 90
    const-string v0, "/models"

    const/4 v1, 0x0

    const-string v2, "GET"

    invoke-static {p0, v2, v0, p1, v1}, Lcom/vorflux/gboardai/OpenAiClient;->request(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lorg/json/JSONObject;)Lorg/json/JSONObject;

    move-result-object p0

    .line 91
    const-string p1, "data"

    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object p0

    .line 92
    if-eqz p0, :cond_a2

    .line 93
    new-instance p1, Ljava/util/ArrayList;

    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    .line 94
    const/4 v0, 0x0

    :goto_17
    invoke-virtual {p0}, Lorg/json/JSONArray;->length()I

    move-result v1

    if-ge v0, v1, :cond_8b

    .line 95
    invoke-virtual {p0, v0}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v1

    const-string v2, ""

    if-nez v1, :cond_26

    goto :goto_30

    :cond_26
    invoke-virtual {p0, v0}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v1

    const-string v3, "id"

    invoke-virtual {v1, v3, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 96
    :goto_30
    sget-object v1, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {v2, v1}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object v1

    .line 97
    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_88

    const-string v3, "embed"

    invoke-virtual {v1, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_88

    const-string v3, "whisper"

    invoke-virtual {v1, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_88

    .line 98
    const-string v3, "tts"

    invoke-virtual {v1, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_88

    const-string v3, "audio"

    invoke-virtual {v1, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_88

    const-string v3, "image"

    invoke-virtual {v1, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_88

    .line 99
    const-string v3, "dall-e"

    invoke-virtual {v1, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_88

    const-string v3, "moderation"

    invoke-virtual {v1, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_88

    const-string v3, "rerank"

    invoke-virtual {v1, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_88

    .line 100
    const-string v3, "transcri"

    invoke-virtual {v1, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_85

    goto :goto_88

    .line 101
    :cond_85
    invoke-interface {p1, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 94
    :cond_88
    :goto_88
    add-int/lit8 v0, v0, 0x1

    goto :goto_17

    .line 103
    :cond_8b
    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result p0

    if-nez p0, :cond_9a

    .line 104
    new-instance p0, Lcom/vorflux/gboardai/OpenAiClient$2;

    invoke-direct {p0}, Lcom/vorflux/gboardai/OpenAiClient$2;-><init>()V

    invoke-static {p1, p0}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    .line 111
    return-object p1

    .line 103
    :cond_9a
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "\u6ca1\u6709\u53ef\u7528\u7684\u6587\u672c\u751f\u6210\u6a21\u578b"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 92
    :cond_a2
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "/models \u672a\u8fd4\u56de\u6a21\u578b\u5217\u8868"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static polish(Landroid/content/Context;Ljava/lang/String;Lcom/vorflux/gboardai/OpenAiClient$Callback;)V
    .registers 4

    .line 31
    nop

    .line 32
    const-string v0, "Polish the user\'s writing in the same language. Improve clarity, fluency, grammar, and naturalness without changing meaning. Preserve formatting and emoji. Return only the polished text."

    invoke-static {p0, v0, p1, p2}, Lcom/vorflux/gboardai/OpenAiClient;->completeAsync(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Lcom/vorflux/gboardai/OpenAiClient$Callback;)V

    .line 33
    return-void
.end method

.method private static readAll(Ljava/io/InputStream;)Ljava/lang/String;
    .registers 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 175
    if-nez p0, :cond_5

    const-string p0, ""

    return-object p0

    .line 176
    :cond_5
    new-instance v0, Ljava/io/BufferedReader;

    new-instance v1, Ljava/io/InputStreamReader;

    sget-object v2, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v1, p0, v2}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/nio/charset/Charset;)V

    invoke-direct {v0, v1}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    .line 177
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    .line 178
    :goto_16
    invoke-virtual {v0}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_26

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const/16 v2, 0xa

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto :goto_16

    .line 179
    :cond_26
    invoke-virtual {v0}, Ljava/io/BufferedReader;->close()V

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static request(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lorg/json/JSONObject;)Lorg/json/JSONObject;
    .registers 8
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 133
    const-string v0, "message"

    new-instance v1, Ljava/net/URL;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getBaseUrl(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v1, p0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object p0

    check-cast p0, Ljava/net/HttpURLConnection;

    .line 135
    :try_start_22
    invoke-virtual {p0, p1}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    .line 136
    const/16 p1, 0x3a98

    invoke-virtual {p0, p1}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    .line 137
    const p1, 0xea60

    invoke-virtual {p0, p1}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    .line 138
    const-string p1, "Authorization"

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Bearer "

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p0, p1, p2}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 139
    const-string p1, "Accept"

    const-string p2, "application/json"

    invoke-virtual {p0, p1, p2}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 140
    if-eqz p4, :cond_76

    .line 141
    const/4 p1, 0x1

    invoke-virtual {p0, p1}, Ljava/net/HttpURLConnection;->setDoOutput(Z)V

    .line 142
    const-string p1, "Content-Type"

    const-string p2, "application/json; charset=utf-8"

    invoke-virtual {p0, p1, p2}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 143
    invoke-virtual {p4}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p1

    sget-object p2, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p1, p2}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p1

    .line 144
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getOutputStream()Ljava/io/OutputStream;

    move-result-object p2
    :try_end_6a
    .catchall {:try_start_22 .. :try_end_6a} :catchall_eb

    .line 145
    :try_start_6a
    invoke-virtual {p2, p1}, Ljava/io/OutputStream;->write([B)V
    :try_end_6d
    .catchall {:try_start_6a .. :try_end_6d} :catchall_71

    :try_start_6d
    invoke-virtual {p2}, Ljava/io/OutputStream;->close()V

    goto :goto_76

    :catchall_71
    move-exception p1

    invoke-virtual {p2}, Ljava/io/OutputStream;->close()V

    throw p1

    .line 147
    :cond_76
    :goto_76
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result p1

    .line 148
    const/16 p2, 0x12c

    const/16 p3, 0xc8

    if-lt p1, p3, :cond_87

    if-ge p1, p2, :cond_87

    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object p4

    goto :goto_8b

    :cond_87
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getErrorStream()Ljava/io/InputStream;

    move-result-object p4

    .line 149
    :goto_8b
    invoke-static {p4}, Lcom/vorflux/gboardai/OpenAiClient;->readAll(Ljava/io/InputStream;)Ljava/lang/String;

    move-result-object p4

    .line 150
    if-lt p1, p3, :cond_9d

    if-lt p1, p2, :cond_94

    goto :goto_9d

    .line 158
    :cond_94
    new-instance p1, Lorg/json/JSONObject;

    invoke-direct {p1, p4}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    :try_end_99
    .catchall {:try_start_6d .. :try_end_99} :catchall_eb

    .line 160
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->disconnect()V

    .line 158
    return-object p1

    .line 151
    :cond_9d
    :goto_9d
    :try_start_9d
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "HTTP "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2
    :try_end_b0
    .catchall {:try_start_9d .. :try_end_b0} :catchall_eb

    .line 153
    :try_start_b0
    new-instance p3, Lorg/json/JSONObject;

    invoke-direct {p3, p4}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string p4, "error"

    invoke-virtual {p3, p4}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object p3

    .line 154
    if-eqz p3, :cond_e4

    invoke-virtual {p3, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p4

    invoke-static {p4}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p4

    if-nez p4, :cond_e4

    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p4, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p4

    const-string v1, ": "

    invoke-virtual {p4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p4

    invoke-virtual {p3, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p4, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2
    :try_end_e2
    .catch Ljava/lang/Exception; {:try_start_b0 .. :try_end_e2} :catch_e3
    .catchall {:try_start_b0 .. :try_end_e2} :catchall_eb

    goto :goto_e4

    .line 155
    :catch_e3
    move-exception p3

    :cond_e4
    :goto_e4
    nop

    .line 156
    :try_start_e5
    new-instance p3, Lcom/vorflux/gboardai/OpenAiClient$HttpStatusException;

    invoke-direct {p3, p1, p2}, Lcom/vorflux/gboardai/OpenAiClient$HttpStatusException;-><init>(ILjava/lang/String;)V

    throw p3
    :try_end_eb
    .catchall {:try_start_e5 .. :try_end_eb} :catchall_eb

    .line 160
    :catchall_eb
    move-exception p1

    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->disconnect()V

    .line 161
    throw p1
.end method

.method private static safeError(Ljava/lang/Exception;)Ljava/lang/String;
    .registers 3

    .line 183
    invoke-virtual {p0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    .line 184
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_12

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    :cond_12
    return-object v0
.end method

.method private static score(Ljava/lang/String;)I
    .registers 3

    .line 119
    sget-object v0, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {p0, v0}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object p0

    .line 120
    nop

    .line 121
    const-string v0, "gpt-4o-mini"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_12

    const/16 v0, 0x3e8

    goto :goto_58

    .line 122
    :cond_12
    const-string v0, "gpt-4.1-mini"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_1d

    const/16 v0, 0x3b6

    goto :goto_58

    .line 123
    :cond_1d
    const-string v0, "gpt-4o"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_28

    const/16 v0, 0x384

    goto :goto_58

    .line 124
    :cond_28
    const-string v0, "gpt-4.1"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_33

    const/16 v0, 0x352

    goto :goto_58

    .line 125
    :cond_33
    const-string v0, "gemini"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_56

    const-string v0, "claude"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_56

    const-string v0, "deepseek"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_56

    const-string v0, "qwen"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_54

    goto :goto_56

    :cond_54
    const/4 v0, 0x0

    goto :goto_58

    :cond_56
    :goto_56
    const/16 v0, 0x2bc

    .line 126
    :goto_58
    const-string v1, "chat"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_68

    const-string v1, "instruct"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_6a

    :cond_68
    add-int/lit8 v0, v0, 0x64

    .line 127
    :cond_6a
    const-string v1, "latest"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_74

    add-int/lit16 v0, v0, -0x96

    .line 128
    :cond_74
    const-string v1, "preview"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_84

    const-string v1, "experimental"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_86

    :cond_84
    add-int/lit16 v0, v0, -0x12c

    .line 129
    :cond_86
    return v0
.end method

.method public static translate(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/vorflux/gboardai/OpenAiClient$Callback;)V
    .registers 7

    .line 25
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "You are Gboard\'s translation engine. Translate the user text from "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string v0, " to "

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string p3, ". Preserve meaning, tone, formatting, emoji, and line breaks. Return only the translated text."

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 27
    invoke-static {p0, p2, p1, p4}, Lcom/vorflux/gboardai/OpenAiClient;->completeAsync(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Lcom/vorflux/gboardai/OpenAiClient$Callback;)V

    .line 28
    return-void
.end method
