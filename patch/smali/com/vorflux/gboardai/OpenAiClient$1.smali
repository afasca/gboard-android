.class Lcom/vorflux/gboardai/OpenAiClient$1;
.super Ljava/lang/Object;
.source "OpenAiClient.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/vorflux/gboardai/OpenAiClient;->completeAsync(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Lcom/vorflux/gboardai/OpenAiClient$Callback;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$callback:Lcom/vorflux/gboardai/OpenAiClient$Callback;

.field final synthetic val$context:Landroid/content/Context;

.field final synthetic val$system:Ljava/lang/String;

.field final synthetic val$text:Ljava/lang/String;


# direct methods
.method constructor <init>(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Lcom/vorflux/gboardai/OpenAiClient$Callback;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 33
    iput-object p1, p0, Lcom/vorflux/gboardai/OpenAiClient$1;->val$context:Landroid/content/Context;

    iput-object p2, p0, Lcom/vorflux/gboardai/OpenAiClient$1;->val$system:Ljava/lang/String;

    iput-object p3, p0, Lcom/vorflux/gboardai/OpenAiClient$1;->val$text:Ljava/lang/String;

    iput-object p4, p0, Lcom/vorflux/gboardai/OpenAiClient$1;->val$callback:Lcom/vorflux/gboardai/OpenAiClient$Callback;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 5

    .line 35
    nop

    .line 36
    nop

    .line 37
    const/4 v0, 0x0

    :try_start_3
    iget-object v1, p0, Lcom/vorflux/gboardai/OpenAiClient$1;->val$context:Landroid/content/Context;

    iget-object v2, p0, Lcom/vorflux/gboardai/OpenAiClient$1;->val$system:Ljava/lang/String;

    iget-object v3, p0, Lcom/vorflux/gboardai/OpenAiClient$1;->val$text:Ljava/lang/String;

    invoke-static {v1, v2, v3}, Lcom/vorflux/gboardai/OpenAiClient;->complete(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1
    :try_end_d
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_d} :catch_11

    .line 38
    move-object v4, v1

    move-object v1, v0

    move-object v0, v4

    goto :goto_16

    :catch_11
    move-exception v1

    invoke-static {v1}, Lcom/vorflux/gboardai/OpenAiClient;->access$000(Ljava/lang/Exception;)Ljava/lang/String;

    move-result-object v1

    .line 39
    :goto_16
    nop

    .line 40
    nop

    .line 41
    new-instance v2, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v3

    invoke-direct {v2, v3}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v3, Lcom/vorflux/gboardai/OpenAiClient$1$1;

    invoke-direct {v3, p0, v0, v1}, Lcom/vorflux/gboardai/OpenAiClient$1$1;-><init>(Lcom/vorflux/gboardai/OpenAiClient$1;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v2, v3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 44
    return-void
.end method
