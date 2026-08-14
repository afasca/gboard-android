.class public final Lcom/vorflux/gboardai/AiPolishListener;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;
.field private final future:Lcom/vorflux/gboardai/AiPolishFuture;
.field private final listener:Ljava/lang/Runnable;
.field private final executor:Ljava/util/concurrent/Executor;
.method public constructor <init>(Lcom/vorflux/gboardai/AiPolishFuture;Ljava/lang/Runnable;Ljava/util/concurrent/Executor;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/vorflux/gboardai/AiPolishListener;->future:Lcom/vorflux/gboardai/AiPolishFuture;
    iput-object p2, p0, Lcom/vorflux/gboardai/AiPolishListener;->listener:Ljava/lang/Runnable;
    iput-object p3, p0, Lcom/vorflux/gboardai/AiPolishListener;->executor:Ljava/util/concurrent/Executor;
    return-void
.end method
.method public run()V
    .locals 2
    :try_start
    iget-object v0, p0, Lcom/vorflux/gboardai/AiPolishListener;->future:Lcom/vorflux/gboardai/AiPolishFuture;
    invoke-virtual {v0}, Lcom/vorflux/gboardai/AiPolishFuture;->get()Ljava/lang/Object;
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :after
    :after
    iget-object v0, p0, Lcom/vorflux/gboardai/AiPolishListener;->executor:Ljava/util/concurrent/Executor;
    iget-object v1, p0, Lcom/vorflux/gboardai/AiPolishListener;->listener:Ljava/lang/Runnable;
    invoke-interface {v0, v1}, Ljava/util/concurrent/Executor;->execute(Ljava/lang/Runnable;)V
    return-void
.end method
