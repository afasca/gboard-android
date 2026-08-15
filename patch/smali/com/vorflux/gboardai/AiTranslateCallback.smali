.class public final Lcom/vorflux/gboardai/AiTranslateCallback;
.super Ljava/lang/Object;
.implements Lcom/vorflux/gboardai/OpenAiClient$Callback;

.field private final provider:Lcom/vorflux/gboardai/AiTranslateProvider;
.field private final generation:I
.field private final callback:Lacgb;

.method public constructor <init>(Lcom/vorflux/gboardai/AiTranslateProvider;ILacgb;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/vorflux/gboardai/AiTranslateCallback;->provider:Lcom/vorflux/gboardai/AiTranslateProvider;
    iput p2, p0, Lcom/vorflux/gboardai/AiTranslateCallback;->generation:I
    iput-object p3, p0, Lcom/vorflux/gboardai/AiTranslateCallback;->callback:Lacgb;
    return-void
.end method

.method public onComplete(Ljava/lang/String;Ljava/lang/String;)V
    .locals 3
    iget-object v0, p0, Lcom/vorflux/gboardai/AiTranslateCallback;->provider:Lcom/vorflux/gboardai/AiTranslateProvider;
    iget v1, p0, Lcom/vorflux/gboardai/AiTranslateCallback;->generation:I
    invoke-static {v0, v1}, Lcom/vorflux/gboardai/AiTranslateProvider;->access$valid(Lcom/vorflux/gboardai/AiTranslateProvider;I)Z
    move-result v0
    if-eqz v0, :done
    if-nez p2, :error
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z
    move-result v0
    if-nez v0, :error
    new-instance v0, Lacif;
    invoke-direct {v0, p1}, Lacif;-><init>(Ljava/lang/String;)V
    goto :send
    :error
    new-instance v0, Lacif;
    const/4 v1, 0x1
    invoke-direct {v0, v1}, Lacif;-><init>(I)V
    :send
    iget-object v1, p0, Lcom/vorflux/gboardai/AiTranslateCallback;->callback:Lacgb;
    invoke-interface {v1, v0}, Lacgb;->a(Lacif;)V
    :done
    return-void
.end method
