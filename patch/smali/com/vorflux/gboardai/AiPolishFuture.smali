.class public final Lcom/vorflux/gboardai/AiPolishFuture;
.super Ljava/lang/Object;
.implements Lbazc;

.field private final delegate:Ljava/util/concurrent/Future;

.method public constructor <init>(Ljava/util/concurrent/Future;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/vorflux/gboardai/AiPolishFuture;->delegate:Ljava/util/concurrent/Future;
    return-void
.end method

.method private convert(Ljava/lang/String;)Lazfk;
    .locals 2
    invoke-static {}, Lakhg;->a()Lakhe;
    move-result-object v0
    invoke-virtual {v0, p1}, Lakhe;->i(Ljava/lang/String;)V
    const/4 p1, 0x0
    invoke-virtual {v0, p1}, Lakhe;->d(I)V
    const-wide/high16 v1, 0x3ff0000000000000L
    invoke-virtual {v0, v1, v2}, Lakhe;->g(D)V
    const-string v1, "openai-compatible"
    invoke-virtual {v0, v1}, Lakhe;->h(Ljava/lang/String;)V
    const-string v1, "auto"
    invoke-virtual {v0, v1}, Lakhe;->f(Ljava/lang/String;)V
    sget-object v1, Lakhh;->a:Lakhh;
    invoke-virtual {v0, v1}, Lakhe;->c(Lakhh;)V
    sget-object v1, Lakdj;->a:Lakdj;
    invoke-virtual {v0, v1}, Lakhe;->j(Lakdj;)V
    sget-object v1, Lakhb;->a:Lakhb;
    invoke-virtual {v0, v1}, Lakhe;->b(Lakhb;)V
    invoke-virtual {v0, p1}, Lakhe;->e(Z)V
    invoke-virtual {v0}, Lakhe;->a()Lakhg;
    move-result-object p1
    invoke-static {p1}, Lazfk;->q(Ljava/lang/Object;)Lazfk;
    move-result-object p1
    return-object p1
.end method

.method public cancel(Z)Z
    .locals 1
    iget-object v0, p0, Lcom/vorflux/gboardai/AiPolishFuture;->delegate:Ljava/util/concurrent/Future;
    invoke-interface {v0, p1}, Ljava/util/concurrent/Future;->cancel(Z)Z
    move-result p1
    return p1
.end method

.method public isCancelled()Z
    .locals 1
    iget-object v0, p0, Lcom/vorflux/gboardai/AiPolishFuture;->delegate:Ljava/util/concurrent/Future;
    invoke-interface {v0}, Ljava/util/concurrent/Future;->isCancelled()Z
    move-result v0
    return v0
.end method

.method public isDone()Z
    .locals 1
    iget-object v0, p0, Lcom/vorflux/gboardai/AiPolishFuture;->delegate:Ljava/util/concurrent/Future;
    invoke-interface {v0}, Ljava/util/concurrent/Future;->isDone()Z
    move-result v0
    return v0
.end method

.method public get()Ljava/lang/Object;
    .locals 1
    iget-object v0, p0, Lcom/vorflux/gboardai/AiPolishFuture;->delegate:Ljava/util/concurrent/Future;
    invoke-interface {v0}, Ljava/util/concurrent/Future;->get()Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;
    invoke-direct {p0, v0}, Lcom/vorflux/gboardai/AiPolishFuture;->convert(Ljava/lang/String;)Lazfk;
    move-result-object v0
    return-object v0
.end method

.method public get(JLjava/util/concurrent/TimeUnit;)Ljava/lang/Object;
    .locals 1
    iget-object v0, p0, Lcom/vorflux/gboardai/AiPolishFuture;->delegate:Ljava/util/concurrent/Future;
    invoke-interface {v0, p1, p2, p3}, Ljava/util/concurrent/Future;->get(JLjava/util/concurrent/TimeUnit;)Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/String;
    invoke-direct {p0, v0}, Lcom/vorflux/gboardai/AiPolishFuture;->convert(Ljava/lang/String;)Lazfk;
    move-result-object v0
    return-object v0
.end method

.method public b(Ljava/lang/Runnable;Ljava/util/concurrent/Executor;)V
    .locals 1
    new-instance v0, Lcom/vorflux/gboardai/AiPolishListener;
    invoke-direct {v0, p0, p1, p2}, Lcom/vorflux/gboardai/AiPolishListener;-><init>(Lcom/vorflux/gboardai/AiPolishFuture;Ljava/lang/Runnable;Ljava/util/concurrent/Executor;)V
    new-instance p1, Ljava/lang/Thread;
    const-string p2, "GboardAI-listener"
    invoke-direct {p1, v0, p2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V
    invoke-virtual {p1}, Ljava/lang/Thread;->start()V
    return-void
.end method
