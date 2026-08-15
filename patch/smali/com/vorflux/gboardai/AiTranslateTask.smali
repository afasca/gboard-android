.class public final Lcom/vorflux/gboardai/AiTranslateTask;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;

.field private final provider:Lcom/vorflux/gboardai/AiTranslateProvider;
.field private final request:Lacie;
.field private final callback:Lacgb;
.field private final generation:I

.method public constructor <init>(Lcom/vorflux/gboardai/AiTranslateProvider;Lacie;Lacgb;I)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/vorflux/gboardai/AiTranslateTask;->provider:Lcom/vorflux/gboardai/AiTranslateProvider;
    iput-object p2, p0, Lcom/vorflux/gboardai/AiTranslateTask;->request:Lacie;
    iput-object p3, p0, Lcom/vorflux/gboardai/AiTranslateTask;->callback:Lacgb;
    iput p4, p0, Lcom/vorflux/gboardai/AiTranslateTask;->generation:I
    return-void
.end method

.method public run()V
    .locals 7
    iget-object v0, p0, Lcom/vorflux/gboardai/AiTranslateTask;->provider:Lcom/vorflux/gboardai/AiTranslateProvider;
    iget v1, p0, Lcom/vorflux/gboardai/AiTranslateTask;->generation:I
    invoke-static {v0, p0, v1}, Lcom/vorflux/gboardai/AiTranslateProvider;->access$dispatch(Lcom/vorflux/gboardai/AiTranslateProvider;Ljava/lang/Runnable;I)Z
    move-result v0
    if-eqz v0, :done

    iget-object v0, p0, Lcom/vorflux/gboardai/AiTranslateTask;->provider:Lcom/vorflux/gboardai/AiTranslateProvider;
    invoke-static {v0}, Lcom/vorflux/gboardai/AiTranslateProvider;->access$context(Lcom/vorflux/gboardai/AiTranslateProvider;)Landroid/content/Context;
    move-result-object v1
    iget-object v2, p0, Lcom/vorflux/gboardai/AiTranslateTask;->request:Lacie;
    iget-object v3, v2, Lacie;->a:Ljava/lang/String;
    iget-object v4, v2, Lacie;->b:Ljava/lang/String;
    iget-object v5, v2, Lacie;->c:Ljava/lang/String;
    new-instance v6, Lcom/vorflux/gboardai/AiTranslateCallback;
    iget v2, p0, Lcom/vorflux/gboardai/AiTranslateTask;->generation:I
    iget-object v0, p0, Lcom/vorflux/gboardai/AiTranslateTask;->provider:Lcom/vorflux/gboardai/AiTranslateProvider;
    iget-object p0, p0, Lcom/vorflux/gboardai/AiTranslateTask;->callback:Lacgb;
    invoke-direct {v6, v0, v2, p0}, Lcom/vorflux/gboardai/AiTranslateCallback;-><init>(Lcom/vorflux/gboardai/AiTranslateProvider;ILacgb;)V
    invoke-static {v1, v3, v4, v5, v6}, Lcom/vorflux/gboardai/OpenAiClient;->translate(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/vorflux/gboardai/OpenAiClient$Callback;)V

    :done
    return-void
.end method
