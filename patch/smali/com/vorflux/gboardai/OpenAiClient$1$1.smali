.class Lcom/vorflux/gboardai/OpenAiClient$1$1;
.super Ljava/lang/Object;
.source "OpenAiClient.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/vorflux/gboardai/OpenAiClient$1;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/vorflux/gboardai/OpenAiClient$1;

.field final synthetic val$finalError:Ljava/lang/String;

.field final synthetic val$finalResult:Ljava/lang/String;


# direct methods
.method constructor <init>(Lcom/vorflux/gboardai/OpenAiClient$1;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 41
    iput-object p1, p0, Lcom/vorflux/gboardai/OpenAiClient$1$1;->this$0:Lcom/vorflux/gboardai/OpenAiClient$1;

    iput-object p2, p0, Lcom/vorflux/gboardai/OpenAiClient$1$1;->val$finalResult:Ljava/lang/String;

    iput-object p3, p0, Lcom/vorflux/gboardai/OpenAiClient$1$1;->val$finalError:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 42
    iget-object v0, p0, Lcom/vorflux/gboardai/OpenAiClient$1$1;->this$0:Lcom/vorflux/gboardai/OpenAiClient$1;

    iget-object v0, v0, Lcom/vorflux/gboardai/OpenAiClient$1;->val$callback:Lcom/vorflux/gboardai/OpenAiClient$Callback;

    iget-object v1, p0, Lcom/vorflux/gboardai/OpenAiClient$1$1;->val$finalResult:Ljava/lang/String;

    iget-object v2, p0, Lcom/vorflux/gboardai/OpenAiClient$1$1;->val$finalError:Ljava/lang/String;

    invoke-interface {v0, v1, v2}, Lcom/vorflux/gboardai/OpenAiClient$Callback;->onComplete(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method
