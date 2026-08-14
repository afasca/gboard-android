.class Lcom/vorflux/gboardai/OpenAiClient$2;
.super Ljava/lang/Object;
.source "OpenAiClient.java"

# interfaces
.implements Ljava/util/Comparator;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/vorflux/gboardai/OpenAiClient;->listModels(Landroid/content/Context;Ljava/lang/String;)Ljava/util/List;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/util/Comparator<",
        "Ljava/lang/String;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 104
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic compare(Ljava/lang/Object;Ljava/lang/Object;)I
    .registers 3

    .line 104
    check-cast p1, Ljava/lang/String;

    check-cast p2, Ljava/lang/String;

    invoke-virtual {p0, p1, p2}, Lcom/vorflux/gboardai/OpenAiClient$2;->compare(Ljava/lang/String;Ljava/lang/String;)I

    move-result p1

    return p1
.end method

.method public compare(Ljava/lang/String;Ljava/lang/String;)I
    .registers 5

    .line 106
    # invokes: Lcom/vorflux/gboardai/OpenAiClient;->score(Ljava/lang/String;)I
    invoke-static {p1}, Lcom/vorflux/gboardai/OpenAiClient;->access$100(Ljava/lang/String;)I

    move-result v0

    # invokes: Lcom/vorflux/gboardai/OpenAiClient;->score(Ljava/lang/String;)I
    invoke-static {p2}, Lcom/vorflux/gboardai/OpenAiClient;->access$100(Ljava/lang/String;)I

    move-result v1

    .line 107
    if-eq v0, v1, :cond_c

    sub-int/2addr v1, v0

    return v1

    .line 108
    :cond_c
    invoke-virtual {p1, p2}, Ljava/lang/String;->compareToIgnoreCase(Ljava/lang/String;)I

    move-result p1

    return p1
.end method
