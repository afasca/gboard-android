.class public final synthetic Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda7;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Landroid/content/DialogInterface$OnShowListener;


# instance fields
.field public final synthetic f$0:Landroid/app/AlertDialog;

.field public final synthetic f$1:Landroid/content/Context;

.field public final synthetic f$2:Landroid/widget/EditText;

.field public final synthetic f$3:Landroid/widget/EditText;

.field public final synthetic f$4:Landroid/widget/EditText;

.field public final synthetic f$5:Landroid/widget/Spinner;

.field public final synthetic f$6:Landroid/widget/Spinner;

.field public final synthetic f$7:Landroid/widget/EditText;


# direct methods
.method public synthetic constructor <init>(Landroid/app/AlertDialog;Landroid/content/Context;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/Spinner;Landroid/widget/Spinner;Landroid/widget/EditText;)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda7;->f$0:Landroid/app/AlertDialog;

    iput-object p2, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda7;->f$1:Landroid/content/Context;

    iput-object p3, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda7;->f$2:Landroid/widget/EditText;

    iput-object p4, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda7;->f$3:Landroid/widget/EditText;

    iput-object p5, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda7;->f$4:Landroid/widget/EditText;

    iput-object p6, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda7;->f$5:Landroid/widget/Spinner;

    iput-object p7, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda7;->f$6:Landroid/widget/Spinner;

    iput-object p8, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda7;->f$7:Landroid/widget/EditText;

    return-void
.end method


# virtual methods
.method public final onShow(Landroid/content/DialogInterface;)V
    .locals 9

    .line 0
    iget-object v0, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda7;->f$0:Landroid/app/AlertDialog;

    iget-object v1, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda7;->f$1:Landroid/content/Context;

    iget-object v2, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda7;->f$2:Landroid/widget/EditText;

    iget-object v3, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda7;->f$3:Landroid/widget/EditText;

    iget-object v4, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda7;->f$4:Landroid/widget/EditText;

    iget-object v5, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda7;->f$5:Landroid/widget/Spinner;

    iget-object v6, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda7;->f$6:Landroid/widget/Spinner;

    iget-object v7, p0, Lcom/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda7;->f$7:Landroid/widget/EditText;

    move-object v8, p1

    invoke-static/range {v0 .. v8}, Lcom/vorflux/gboardai/AiSettingsDialog;->lambda$show$6(Landroid/app/AlertDialog;Landroid/content/Context;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/Spinner;Landroid/widget/Spinner;Landroid/widget/EditText;Landroid/content/DialogInterface;)V

    return-void
.end method
