.class public final Lcom/vorflux/gboardai/AiSettingsClick;
.super Ljava/lang/Object;
.implements Leaf;
.field private final context:Landroid/content/Context;
.method public constructor <init>(Landroid/content/Context;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/vorflux/gboardai/AiSettingsClick;->context:Landroid/content/Context;
    return-void
.end method
.method public b(Landroidx/preference/Preference;)Z
    .locals 1
    iget-object v0, p0, Lcom/vorflux/gboardai/AiSettingsClick;->context:Landroid/content/Context;
    invoke-static {v0}, Lcom/vorflux/gboardai/AiSettingsDialog;->show(Landroid/content/Context;)V
    const/4 v0, 0x1
    return v0
.end method
