.class public final Lcom/vorflux/gboardai/AiTranslateProvider;
.super Ljava/lang/Object;
.implements Lacgc;

.field private final context:Landroid/content/Context;
.field private generation:I
.field private closed:Z

.method public constructor <init>(Landroid/content/Context;)V
    .locals 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
    move-result-object v0
    iput-object v0, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->context:Landroid/content/Context;
    return-void
.end method

.method public b(Ljava/util/Locale;Lacga;)V
    .locals 9
    if-eqz p2, :done
    new-instance v0, Ljava/util/LinkedHashMap;
    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V
    new-instance v1, Ljava/util/LinkedHashMap;
    invoke-direct {v1}, Ljava/util/LinkedHashMap;-><init>()V
    const-string v2, "auto"
    iget-object v3, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->context:Landroid/content/Context;
    const v4, 0x7f14121b
    invoke-virtual {v3, v4}, Landroid/content/Context;->getString(I)Ljava/lang/String;
    move-result-object v3
    invoke-interface {v0, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    sget-object v2, Laciy;->a:Lazfk;
    invoke-virtual {v2}, Ljava/util/AbstractCollection;->iterator()Ljava/util/Iterator;
    move-result-object v2
    :source_loop
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z
    move-result v3
    if-eqz v3, :targets
    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v3
    check-cast v3, Ljava/lang/String;
    invoke-static {v3}, Laqkh;->e(Ljava/lang/String;)Laqkh;
    move-result-object v4
    iget-object v5, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->context:Landroid/content/Context;
    invoke-virtual {v4, v5, p1}, Laqkh;->n(Landroid/content/Context;Ljava/util/Locale;)Ljava/lang/CharSequence;
    move-result-object v4
    invoke-interface {v0, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    goto :source_loop
    :targets
    sget-object v2, Laciy;->b:Lazfk;
    invoke-virtual {v2}, Ljava/util/AbstractCollection;->iterator()Ljava/util/Iterator;
    move-result-object v2
    :target_loop
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z
    move-result v3
    if-eqz v3, :callback
    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v3
    check-cast v3, Ljava/lang/String;
    invoke-static {v3}, Laqkh;->e(Ljava/lang/String;)Laqkh;
    move-result-object v4
    iget-object v5, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->context:Landroid/content/Context;
    invoke-virtual {v4, v5, p1}, Laqkh;->n(Landroid/content/Context;Ljava/util/Locale;)Ljava/lang/CharSequence;
    move-result-object v4
    invoke-interface {v1, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    goto :target_loop
    :callback
    invoke-interface {p2, v0, v1}, Lacga;->a(Ljava/util/Map;Ljava/util/Map;)V
    :done
    return-void
.end method

.method public d(Lacie;Lacgb;)V
    .locals 6
    if-eqz p1, :bad
    if-eqz p2, :return
    iget-object v0, p1, Lacie;->a:Ljava/lang/String;
    iget-boolean v1, p1, Lacie;->e:Z
    if-eqz v1, :user_request
    new-instance v1, Lacif;
    const-string v2, "hola"
    invoke-direct {v1, v2}, Lacif;-><init>(Ljava/lang/String;)V
    invoke-interface {p2, v1}, Lacgb;->a(Lacif;)V
    return-void
    :user_request
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z
    move-result v1
    if-nez v1, :bad
    iget v1, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->generation:I
    iget-object v2, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->context:Landroid/content/Context;
    iget-object v3, p1, Lacie;->b:Ljava/lang/String;
    iget-object v4, p1, Lacie;->c:Ljava/lang/String;
    new-instance v5, Lcom/vorflux/gboardai/AiTranslateCallback;
    invoke-direct {v5, p0, v1, p2}, Lcom/vorflux/gboardai/AiTranslateCallback;-><init>(Lcom/vorflux/gboardai/AiTranslateProvider;ILacgb;)V
    invoke-static {v2, v0, v3, v4, v5}, Lcom/vorflux/gboardai/OpenAiClient;->translate(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/vorflux/gboardai/OpenAiClient$Callback;)V
    return-void
    :bad
    if-eqz p2, :return
    new-instance v0, Lacif;
    const/4 v1, 0x2
    invoke-direct {v0, v1}, Lacif;-><init>(I)V
    invoke-interface {p2, v0}, Lacgb;->a(Lacif;)V
    :return
    return-void
.end method

.method public c()V
    .locals 1
    iget v0, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->generation:I
    add-int/lit8 v0, v0, 0x1
    iput v0, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->generation:I
    return-void
.end method

.method public close()V
    .locals 1
    const/4 v0, 0x1
    iput-boolean v0, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->closed:Z
    invoke-virtual {p0}, Lcom/vorflux/gboardai/AiTranslateProvider;->c()V
    return-void
.end method

.method public f(Ljava/lang/String;Ljava/lang/String;)Z
    .locals 1
    const/4 v0, 0x0
    return v0
.end method

.method public fV()V
    .locals 0
    return-void
.end method

.method public static access$valid(Lcom/vorflux/gboardai/AiTranslateProvider;I)Z
    .locals 2
    iget-boolean v0, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->closed:Z
    const/4 v1, 0x0
    if-nez v0, :done
    iget v0, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->generation:I
    if-ne v0, p1, :done
    const/4 v1, 0x1
    :done
    return v1
.end method
