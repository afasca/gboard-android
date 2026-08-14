.class Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1$1;
.super Ljava/lang/Object;
.source "AiSettingsDialog.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$2:Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;

.field final synthetic val$available:Ljava/util/List;

.field final synthetic val$problem:Ljava/lang/String;


# direct methods
.method constructor <init>(Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;Ljava/lang/String;Ljava/util/List;)V
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 65
    iput-object p1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1$1;->this$2:Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;

    iput-object p2, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1$1;->val$problem:Ljava/lang/String;

    iput-object p3, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1$1;->val$available:Ljava/util/List;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    .line 67
    iget-object v0, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1$1;->this$2:Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;

    iget-object v0, v0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;->this$1:Lcom/vorflux/gboardai/AiSettingsDialog$1$2;

    iget-object v0, v0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2;->val$shown:Landroid/app/AlertDialog;

    const/4 v1, -0x1

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog;->getButton(I)Landroid/widget/Button;

    move-result-object v0

    const/4 v2, 0x1

    invoke-virtual {v0, v2}, Landroid/widget/Button;->setEnabled(Z)V

    .line 68
    iget-object v0, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1$1;->this$2:Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;

    iget-object v0, v0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;->this$1:Lcom/vorflux/gboardai/AiSettingsDialog$1$2;

    iget-object v0, v0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2;->val$shown:Landroid/app/AlertDialog;

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog;->getButton(I)Landroid/widget/Button;

    move-result-object v0

    const-string v1, "\u4fdd\u5b58\u5e76\u9009\u62e9\u6a21\u578b"

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 69
    iget-object v0, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1$1;->val$problem:Ljava/lang/String;

    if-eqz v0, :cond_47

    .line 70
    new-instance v0, Landroid/app/AlertDialog$Builder;

    iget-object v1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1$1;->this$2:Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;

    iget-object v1, v1, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;->this$1:Lcom/vorflux/gboardai/AiSettingsDialog$1$2;

    iget-object v1, v1, Lcom/vorflux/gboardai/AiSettingsDialog$1$2;->this$0:Lcom/vorflux/gboardai/AiSettingsDialog$1;

    iget-object v1, v1, Lcom/vorflux/gboardai/AiSettingsDialog$1;->val$context:Landroid/content/Context;

    invoke-direct {v0, v1}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v1, "\u6a21\u578b\u83b7\u53d6\u5931\u8d25"

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    iget-object v1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1$1;->val$problem:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    const v1, 0x104000a

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/app/AlertDialog$Builder;->setPositiveButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 71
    return-void

    .line 73
    :cond_47
    iget-object v0, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1$1;->this$2:Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;

    iget-object v0, v0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;->this$1:Lcom/vorflux/gboardai/AiSettingsDialog$1$2;

    iget-object v0, v0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2;->this$0:Lcom/vorflux/gboardai/AiSettingsDialog$1;

    iget-object v0, v0, Lcom/vorflux/gboardai/AiSettingsDialog$1;->val$context:Landroid/content/Context;

    iget-object v1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1$1;->this$2:Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;

    iget-object v1, v1, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1;->this$1:Lcom/vorflux/gboardai/AiSettingsDialog$1$2;

    iget-object v1, v1, Lcom/vorflux/gboardai/AiSettingsDialog$1$2;->val$shown:Landroid/app/AlertDialog;

    iget-object v2, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$2$1$1;->val$available:Ljava/util/List;

    # invokes: Lcom/vorflux/gboardai/AiSettingsDialog;->showModelPicker(Landroid/content/Context;Landroid/app/AlertDialog;Ljava/util/List;)V
    invoke-static {v0, v1, v2}, Lcom/vorflux/gboardai/AiSettingsDialog;->access$100(Landroid/content/Context;Landroid/app/AlertDialog;Ljava/util/List;)V

    .line 74
    return-void
.end method
