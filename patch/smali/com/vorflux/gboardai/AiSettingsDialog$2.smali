.class Lcom/vorflux/gboardai/AiSettingsDialog$2;
.super Ljava/lang/Object;
.source "AiSettingsDialog.java"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/vorflux/gboardai/AiSettingsDialog;->showModelPicker(Landroid/content/Context;Landroid/app/AlertDialog;Ljava/util/List;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$context:Landroid/content/Context;

.field final synthetic val$models:Ljava/util/List;

.field final synthetic val$settings:Landroid/app/AlertDialog;


# direct methods
.method constructor <init>(Landroid/content/Context;Ljava/util/List;Landroid/app/AlertDialog;)V
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 108
    iput-object p1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$2;->val$context:Landroid/content/Context;

    iput-object p2, p0, Lcom/vorflux/gboardai/AiSettingsDialog$2;->val$models:Ljava/util/List;

    iput-object p3, p0, Lcom/vorflux/gboardai/AiSettingsDialog$2;->val$settings:Landroid/app/AlertDialog;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .registers 7

    .line 110
    const/4 v0, 0x1

    if-nez p2, :cond_3d

    .line 111
    iget-object p2, p0, Lcom/vorflux/gboardai/AiSettingsDialog$2;->val$context:Landroid/content/Context;

    const-string v1, ""

    invoke-static {p2, v1}, Lcom/vorflux/gboardai/AiConfig;->setManualModel(Landroid/content/Context;Ljava/lang/String;)V

    .line 112
    iget-object p2, p0, Lcom/vorflux/gboardai/AiSettingsDialog$2;->val$context:Landroid/content/Context;

    iget-object v1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$2;->val$models:Ljava/util/List;

    const/4 v2, 0x0

    invoke-interface {v1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-static {p2, v1}, Lcom/vorflux/gboardai/AiConfig;->setCachedModel(Landroid/content/Context;Ljava/lang/String;)V

    .line 113
    iget-object p2, p0, Lcom/vorflux/gboardai/AiSettingsDialog$2;->val$context:Landroid/content/Context;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u5df2\u5207\u6362\u4e3a\u81ea\u52a8\u6a21\u5f0f\uff1a"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v3, p0, Lcom/vorflux/gboardai/AiSettingsDialog$2;->val$models:Ljava/util/List;

    invoke-interface {v3, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {p2, v1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p2

    invoke-virtual {p2}, Landroid/widget/Toast;->show()V

    goto :goto_67

    .line 115
    :cond_3d
    iget-object v1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$2;->val$models:Ljava/util/List;

    sub-int/2addr p2, v0

    invoke-interface {v1, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Ljava/lang/String;

    .line 116
    iget-object v1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$2;->val$context:Landroid/content/Context;

    invoke-static {v1, p2}, Lcom/vorflux/gboardai/AiConfig;->setManualModel(Landroid/content/Context;Ljava/lang/String;)V

    .line 117
    iget-object v1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$2;->val$context:Landroid/content/Context;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u5df2\u624b\u52a8\u9009\u62e9\u6a21\u578b\uff1a"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {v1, p2, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p2

    invoke-virtual {p2}, Landroid/widget/Toast;->show()V

    .line 119
    :goto_67
    invoke-interface {p1}, Landroid/content/DialogInterface;->dismiss()V

    .line 120
    iget-object p1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$2;->val$settings:Landroid/app/AlertDialog;

    invoke-virtual {p1}, Landroid/app/AlertDialog;->dismiss()V

    .line 121
    return-void
.end method
