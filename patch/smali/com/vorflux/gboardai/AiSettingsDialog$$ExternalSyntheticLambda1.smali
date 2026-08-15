.class public final synthetic Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Landroid/content/Context;

.field public final synthetic f$1:Ljava/lang/String;

.field public final synthetic f$2:Landroid/app/AlertDialog;

.field public final synthetic f$3:Landroid/widget/Button;


# direct methods
.method public synthetic constructor <init>(Landroid/content/Context;Ljava/lang/String;Landroid/app/AlertDialog;Landroid/widget/Button;)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda1;->f$0:Landroid/content/Context;

    iput-object p2, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda1;->f$1:Ljava/lang/String;

    iput-object p3, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda1;->f$2:Landroid/app/AlertDialog;

    iput-object p4, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda1;->f$3:Landroid/widget/Button;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 4

    .line 0
    iget-object v0, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda1;->f$0:Landroid/content/Context;

    iget-object v1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda1;->f$1:Ljava/lang/String;

    iget-object v2, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda1;->f$2:Landroid/app/AlertDialog;

    iget-object v3, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda1;->f$3:Landroid/widget/Button;

    invoke-static {v0, v1, v2, v3}, Lcom/vorflux/gboardai/AiSettingsDialog;->lambda$show$4(Landroid/content/Context;Ljava/lang/String;Landroid/app/AlertDialog;Landroid/widget/Button;)V

    return-void
.end method
