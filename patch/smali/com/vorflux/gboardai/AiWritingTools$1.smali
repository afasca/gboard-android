.class Lcom/vorflux/gboardai/AiWritingTools$1;
.super Ljava/lang/Object;
.source "AiWritingTools.java"

# interfaces
.implements Ljava/util/concurrent/Callable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/vorflux/gboardai/AiWritingTools;->polish(Landroid/content/Context;Ljava/lang/String;)Ljava/util/concurrent/Future;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/util/concurrent/Callable<",
        "Ljava/lang/String;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic val$context:Landroid/content/Context;

.field final synthetic val$text:Ljava/lang/String;


# direct methods
.method constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 10
    iput-object p1, p0, Lcom/vorflux/gboardai/AiWritingTools$1;->val$context:Landroid/content/Context;

    iput-object p2, p0, Lcom/vorflux/gboardai/AiWritingTools$1;->val$text:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic call()Ljava/lang/Object;
    .registers 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 10
    invoke-virtual {p0}, Lcom/vorflux/gboardai/AiWritingTools$1;->call()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public call()Ljava/lang/String;
    .registers 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 12
    iget-object v0, p0, Lcom/vorflux/gboardai/AiWritingTools$1;->val$context:Landroid/content/Context;

    const-string v1, "Polish the user\'s writing in the same language. Improve clarity, fluency, grammar, and naturalness without changing meaning. Preserve formatting and emoji. Return only the polished text."

    iget-object v2, p0, Lcom/vorflux/gboardai/AiWritingTools$1;->val$text:Ljava/lang/String;

    invoke-static {v0, v1, v2}, Lcom/vorflux/gboardai/OpenAiClient;->complete(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
