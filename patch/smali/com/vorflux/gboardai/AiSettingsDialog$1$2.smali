.class Lcom/vorflux/gboardai/AiSettingsDialog$1$2;
.super Ljava/lang/Object;
.source "AiSettingsDialog.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/vorflux/gboardai/AiSettingsDialog$1;->onShow(Landroid/content/DialogInterface;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/vorflux/gboardai/AiSettingsDialog$1;

.field final synthetic val$shown:Landroid/app/AlertDialog;


# direct methods
.method constructor <init>(Lcom/vorflux/gboardai/AiSettingsDialog$1;Landroid/app/AlertDialog;)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 52
    iput-object p1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2;->this$0:Lcom/vorflux/gboardai/AiSettingsDialog$1;

    iput-object p2, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2;->val$shown:Landroid/app/AlertDialog;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 5

    .line 54
    iget-object p1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2;->this$0:Lcom/vorflux/gboardai/AiSettingsDialog$1;

    iget-object p1, p1, Lcom/vorflux/gboardai/AiSettingsDialog$1;->val$context:Landroid/content/Context;

    iget-object v0, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2;->this$0:Lcom/vorflux/gboardai/AiSettingsDialog$1;

    iget-object v0, v0, Lcom/vorflux/gboardai/AiSettingsDialog$1;->val$base:Landroid/widget/EditText;

    iget-object v1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2;->this$0:Lcom/vorflux/gboardai/AiSettingsDialog$1;

    iget-object v1, v1, Lcom/vorflux/gboardai/AiSettingsDialog$1;->val$key:Landroid/widget/EditText;

    # invokes: Lcom/vorflux/gboardai/AiSettingsDialog;->saveConnection(Landroid/content/Context;Landroid/widget/EditText;Landroid/widget/EditText;)Z
    invoke-static {p1, v0, v1}, Lcom/vorflux/gboardai/AiSettingsDialog;->access$000(Landroid/content/Context;Landroid/widget/EditText;Landroid/widget/EditText;)Z

    move-result p1

    if-nez p1, :cond_13

    return-void

    .line 55
    :cond_13
    iget-object p1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2;->this$0:Lcom/vorflux/gboardai/AiSettingsDialog$1;

    iget-object p1, p1, Lcom/vorflux/gboardai/AiSettingsDialog$1;->val$context:Landroid/content/Context;

    invoke-static {p1}, Lcom/vorflux/gboardai/AiConfig;->getApiKey(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p1

    .line 56
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    if-nez v0, :cond_2b

    iget-object p1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2;->this$0:Lcom/vorflux/gboardai/AiSettingsDialog$1;

    iget-object p1, p1, Lcom/vorflux/gboardai/AiSettingsDialog$1;->val$key:Landroid/widget/EditText;

    const-string v0, "\u8bf7\u586b\u5199 API Key"

    invoke-virtual {p1, v0}, Landroid/widget/EditText;->setError(Ljava/lang/CharSequence;)V

    return-void

    .line 57
    :cond_2b
    iget-object v0, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2;->val$shown:Landroid/app/AlertDialog;

    const/4 v1, -0x1

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog;->getButton(I)Landroid/widget/Button;

    move-result-object v0

    const/4 v2, 0x0

    invoke-virtual {v0, v2}, Landroid/widget/Button;->setEnabled(Z)V

    .line 58
    iget-object v0, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2;->val$shown:Landroid/app/AlertDialog;

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog;->getButton(I)Landroid/widget/Button;

    move-result-object v0

    const-string v1, "\u6b63\u5728\u83b7\u53d6\u6a21\u578b\u2026"

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 59
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;

    invoke-direct {v1, p0, p1}, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;-><init>(Lcom/vorflux/gboardai/AiSettingsDialog$1$2;Ljava/lang/String;)V

    const-string p1, "GboardAI-models"

    invoke-direct {v0, v1, p1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    .line 77
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    .line 78
    return-void
.end method
