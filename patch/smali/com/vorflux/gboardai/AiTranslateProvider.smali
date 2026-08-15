.class public final Lcom/vorflux/gboardai/AiTranslateProvider;
.super Ljava/lang/Object;
.implements Lacgc;

.field private final context:Landroid/content/Context;
.field private final handler:Landroid/os/Handler;
.field private generation:I
.field private closed:Z
.field private pending:Ljava/lang/Runnable;

.method public constructor <init>(Landroid/content/Context;)V
    .locals 2
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
    move-result-object v0
    iput-object v0, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->context:Landroid/content/Context;
    new-instance v0, Landroid/os/Handler;
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v1
    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V
    iput-object v0, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->handler:Landroid/os/Handler;
    return-void
.end method

.method public b(Ljava/util/Locale;Lacga;)V
    .locals 6
    if-eqz p2, :done

    new-instance v0, Ljava/util/LinkedHashMap;
    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V
    new-instance v1, Ljava/util/LinkedHashMap;
    invoke-direct {v1}, Ljava/util/LinkedHashMap;-><init>()V

    const-string v2, "auto"
    iget-object v3, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->context:Landroid/content/Context;
    invoke-static {v3, p1}, Laciy;->d(Landroid/content/Context;Ljava/util/Locale;)Ljava/lang/String;
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
    const-string v4, "auto"
    invoke-virtual {v4, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v4
    if-nez v4, :source_loop
    invoke-static {v3}, Laciy;->b(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    invoke-static {v3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z
    move-result v4
    if-nez v4, :source_loop
    invoke-static {v3, p1}, Laqkl;->a(Ljava/lang/String;Ljava/util/Locale;)Ljava/lang/String;
    move-result-object v4
    invoke-static {v4}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z
    move-result v5
    if-nez v5, :source_loop
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
    invoke-static {v3}, Laciy;->c(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    invoke-static {v3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z
    move-result v4
    if-nez v4, :target_loop
    invoke-static {v3, p1}, Laqkl;->a(Ljava/lang/String;Ljava/util/Locale;)Ljava/lang/String;
    move-result-object v4
    invoke-static {v4}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z
    move-result v5
    if-nez v5, :target_loop
    invoke-interface {v1, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    goto :target_loop

    :callback
    invoke-interface {p2, v0, v1}, Lacga;->a(Ljava/util/Map;Ljava/util/Map;)V
    :done
    return-void
.end method

.method public declared-synchronized d(Lacie;Lacgb;)V
    .locals 7
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
    iget-boolean v1, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->closed:Z
    if-nez v1, :return

    iget-object v1, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->pending:Ljava/lang/Runnable;
    if-eqz v1, :increment
    iget-object v2, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->handler:Landroid/os/Handler;
    invoke-virtual {v2, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    :increment
    iget v1, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->generation:I
    add-int/lit8 v1, v1, 0x1
    iput v1, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->generation:I
    new-instance v2, Lcom/vorflux/gboardai/AiTranslateTask;
    invoke-direct {v2, p0, p1, p2, v1}, Lcom/vorflux/gboardai/AiTranslateTask;-><init>(Lcom/vorflux/gboardai/AiTranslateProvider;Lacie;Lacgb;I)V
    iput-object v2, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->pending:Ljava/lang/Runnable;
    iget-object v3, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->context:Landroid/content/Context;
    invoke-static {v3}, Lcom/vorflux/gboardai/AiConfig;->getDebounceMs(Landroid/content/Context;)I
    move-result v3
    int-to-long v3, v3
    iget-object v5, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->handler:Landroid/os/Handler;
    invoke-virtual {v5, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
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

.method public declared-synchronized c()V
    .locals 2
    iget-object v0, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->pending:Ljava/lang/Runnable;
    if-eqz v0, :invalidate
    iget-object v1, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->handler:Landroid/os/Handler;
    invoke-virtual {v1, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V
    const/4 v0, 0x0
    iput-object v0, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->pending:Ljava/lang/Runnable;
    :invalidate
    iget v0, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->generation:I
    add-int/lit8 v0, v0, 0x1
    iput v0, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->generation:I
    return-void
.end method

.method public declared-synchronized close()V
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
    .locals 3
    monitor-enter p0
    :try_start
    iget-boolean v0, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->closed:Z
    const/4 v1, 0x0
    if-nez v0, :done
    iget v0, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->generation:I
    if-ne v0, p1, :done
    const/4 v1, 0x1
    :done
    monitor-exit p0
    return v1
    :catchall
    move-exception v2
    monitor-exit p0
    throw v2
    :try_end
    .catchall {:try_start .. :try_end} :catchall
.end method

.method public static access$dispatch(Lcom/vorflux/gboardai/AiTranslateProvider;Ljava/lang/Runnable;I)Z
    .locals 3
    monitor-enter p0
    :try_start
    iget-boolean v0, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->closed:Z
    const/4 v1, 0x0
    if-nez v0, :done
    iget v0, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->generation:I
    if-ne v0, p2, :done
    iget-object v0, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->pending:Ljava/lang/Runnable;
    if-ne v0, p1, :done
    const/4 v0, 0x0
    iput-object v0, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->pending:Ljava/lang/Runnable;
    const/4 v1, 0x1
    :done
    monitor-exit p0
    return v1
    :catchall
    move-exception v2
    monitor-exit p0
    throw v2
    :try_end
    .catchall {:try_start .. :try_end} :catchall
.end method

.method public static access$context(Lcom/vorflux/gboardai/AiTranslateProvider;)Landroid/content/Context;
    .locals 1
    iget-object v0, p0, Lcom/vorflux/gboardai/AiTranslateProvider;->context:Landroid/content/Context;
    return-object v0
.end method
