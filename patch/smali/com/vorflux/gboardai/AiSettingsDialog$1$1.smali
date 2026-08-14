.class Lcom/vorflux/gboardai/AiSettingsDialog$1$1;
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


# direct methods
.method constructor <init>(Lcom/vorflux/gboardai/AiSettingsDialog$1;)V
    .registers 2

    .line 45
    iput-object p1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$1;->this$0:Lcom/vorflux/gboardai/AiSettingsDialog$1;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 4

    .line 47
    iget-object p1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$1;->this$0:Lcom/vorflux/gboardai/AiSettingsDialog$1;

    iget-object p1, p1, Lcom/vorflux/gboardai/AiSettingsDialog$1;->val$context:Landroid/content/Context;

    const-string v0, ""

    invoke-static {p1, v0}, Lcom/vorflux/gboardai/AiConfig;->setApiKey(Landroid/content/Context;Ljava/lang/String;)V

    iget-object p1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$1;->this$0:Lcom/vorflux/gboardai/AiSettingsDialog$1;

    iget-object p1, p1, Lcom/vorflux/gboardai/AiSettingsDialog$1;->val$key:Landroid/widget/EditText;

    invoke-virtual {p1, v0}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 48
    iget-object p1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1$1;->this$0:Lcom/vorflux/gboardai/AiSettingsDialog$1;

    iget-object p1, p1, Lcom/vorflux/gboardai/AiSettingsDialog$1;->val$context:Landroid/content/Context;

    const-string v0, "API Key \u5df2\u6e05\u9664"

    const/4 v1, 0x0

    invoke-static {p1, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 49
    return-void
.end method
