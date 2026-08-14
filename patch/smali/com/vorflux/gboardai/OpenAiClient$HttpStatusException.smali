.class final Lcom/vorflux/gboardai/OpenAiClient$HttpStatusException;
.super Ljava/lang/IllegalStateException;
.source "OpenAiClient.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/vorflux/gboardai/OpenAiClient;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "HttpStatusException"
.end annotation


# instance fields
.field private final code:I


# direct methods
.method constructor <init>(ILjava/lang/String;)V
    .registers 3

    .line 158
    invoke-direct {p0, p2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    iput p1, p0, Lcom/vorflux/gboardai/OpenAiClient$HttpStatusException;->code:I

    return-void
.end method


# virtual methods
.method isMissingModel()Z
    .registers 4

    .line 160
    invoke-virtual {p0}, Lcom/vorflux/gboardai/OpenAiClient$HttpStatusException;->getMessage()Ljava/lang/String;

    move-result-object v0

    .line 161
    iget v1, p0, Lcom/vorflux/gboardai/OpenAiClient$HttpStatusException;->code:I

    const/16 v2, 0x194

    if-eq v1, v2, :cond_23

    iget v1, p0, Lcom/vorflux/gboardai/OpenAiClient$HttpStatusException;->code:I

    const/16 v2, 0x190

    if-ne v1, v2, :cond_21

    if-eqz v0, :cond_21

    sget-object v1, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {v0, v1}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "model"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_21

    goto :goto_23

    :cond_21
    const/4 v0, 0x0

    goto :goto_24

    :cond_23
    :goto_23
    const/4 v0, 0x1

    :goto_24
    return v0
.end method
