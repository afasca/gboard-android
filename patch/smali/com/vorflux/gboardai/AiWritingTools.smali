.class public final Lcom/vorflux/gboardai/AiWritingTools;
.super Ljava/lang/Object;
.source "AiWritingTools.java"


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static polish(Landroid/content/Context;Ljava/lang/String;)Ljava/util/concurrent/Future;
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/concurrent/Future<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 10
    new-instance v0, Ljava/util/concurrent/FutureTask;

    new-instance v1, Lcom/vorflux/gboardai/AiWritingTools$1;

    invoke-direct {v1, p0, p1}, Lcom/vorflux/gboardai/AiWritingTools$1;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/util/concurrent/FutureTask;-><init>(Ljava/util/concurrent/Callable;)V

    .line 17
    new-instance p0, Ljava/lang/Thread;

    const-string p1, "GboardAI-writing-tools"

    invoke-direct {p0, v0, p1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/lang/Thread;->start()V

    .line 18
    return-object v0
.end method
