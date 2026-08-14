.class Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;
.super Ljava/lang/Object;
.source "AiSettingsDialog.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/vorflux/gboardai/AiSettingsDialog$1$2;->onClick(Landroid/view/View;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Lcom/vorflux/gboardai/AiSettingsDialog$1$2;

.field final synthetic val$apiKey:Ljava/lang/String;


# direct methods
.method constructor <init>(Lcom/vorflux/gboardai/AiSettingsDialog$1$2;Ljava/lang/String;)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 62
    iput-object p1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;->this$1:Lcom/vorflux/gboardai/AiSettingsDialog$1$2;

    iput-object p2, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;->val$apiKey:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 6

    .line 64
    nop

    .line 65
    const/4 v0, 0x0

    :try_start_2
    iget-object v1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;->this$1:Lcom/vorflux/gboardai/AiSettingsDialog$1$2;

    iget-object v1, v1, Lcom/vorflux/gboardai/AiSettingsDialog$1$2;->this$0:Lcom/vorflux/gboardai/AiSettingsDialog$1;

    iget-object v1, v1, Lcom/vorflux/gboardai/AiSettingsDialog$1;->val$context:Landroid/content/Context;

    iget-object v2, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;->val$apiKey:Ljava/lang/String;

    invoke-static {v1, v2}, Lcom/vorflux/gboardai/OpenAiClient;->discoverModel(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1
    :try_end_e
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_e} :catch_1a

    :try_start_e
    iget-object v2, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;->this$1:Lcom/vorflux/gboardai/AiSettingsDialog$1$2;

    iget-object v2, v2, Lcom/vorflux/gboardai/AiSettingsDialog$1$2;->this$0:Lcom/vorflux/gboardai/AiSettingsDialog$1;

    iget-object v2, v2, Lcom/vorflux/gboardai/AiSettingsDialog$1;->val$context:Landroid/content/Context;

    invoke-static {v2, v1}, Lcom/vorflux/gboardai/AiConfig;->setCachedModel(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_17
    .catch Ljava/lang/Exception; {:try_start_e .. :try_end_17} :catch_18

    .line 66
    goto :goto_22

    :catch_18
    move-exception v0

    goto :goto_1e

    :catch_1a
    move-exception v1

    move-object v4, v1

    move-object v1, v0

    move-object v0, v4

    :goto_1e
    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    .line 67
    :goto_22
    nop

    .line 68
    iget-object v2, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;->this$1:Lcom/vorflux/gboardai/AiSettingsDialog$1$2;

    iget-object v2, v2, Lcom/vorflux/gboardai/AiSettingsDialog$1$2;->val$shown:Landroid/app/AlertDialog;

    invoke-virtual {v2}, Landroid/app/AlertDialog;->getWindow()Landroid/view/Window;

    move-result-object v2

    invoke-virtual {v2}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v2

    new-instance v3, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1$1;

    invoke-direct {v3, p0, v0, v1}, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1$1;-><init>(Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v2, v3}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    .line 80
    return-void
.end method
