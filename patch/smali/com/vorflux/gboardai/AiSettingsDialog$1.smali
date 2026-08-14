.class Lcom/vorflux/gboardai/AiSettingsDialog$1;
.super Ljava/lang/Object;
.source "AiSettingsDialog.java"

# interfaces
.implements Landroid/content/DialogInterface$OnShowListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/vorflux/gboardai/AiSettingsDialog;->show(Landroid/content/Context;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$base:Landroid/widget/EditText;

.field final synthetic val$context:Landroid/content/Context;

.field final synthetic val$key:Landroid/widget/EditText;


# direct methods
.method constructor <init>(Landroid/content/Context;Landroid/widget/EditText;Landroid/widget/EditText;)V
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 42
    iput-object p1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1;->val$context:Landroid/content/Context;

    iput-object p2, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1;->val$key:Landroid/widget/EditText;

    iput-object p3, p0, Lcom/vorflux/gboardai/AiSettingsDialog$1;->val$base:Landroid/widget/EditText;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onShow(Landroid/content/DialogInterface;)V
    .registers 4

    .line 44
    check-cast p1, Landroid/app/AlertDialog;

    .line 45
    const/4 v0, -0x3

    invoke-virtual {p1, v0}, Landroid/app/AlertDialog;->getButton(I)Landroid/widget/Button;

    move-result-object v0

    new-instance v1, Lcom/vorflux/gboardai/AiSettingsDialog$1$1;

    invoke-direct {v1, p0}, Lcom/vorflux/gboardai/AiSettingsDialog$1$1;-><init>(Lcom/vorflux/gboardai/AiSettingsDialog$1;)V

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 51
    const/4 v0, -0x1

    invoke-virtual {p1, v0}, Landroid/app/AlertDialog;->getButton(I)Landroid/widget/Button;

    move-result-object v0

    new-instance v1, Lcom/vorflux/gboardai/AiSettingsDialog$1$2;

    invoke-direct {v1, p0, p1}, Lcom/vorflux/gboardai/AiSettingsDialog$1$2;-><init>(Lcom/vorflux/gboardai/AiSettingsDialog$1;Landroid/app/AlertDialog;)V

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 84
    return-void
.end method
