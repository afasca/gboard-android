.class public final Lcom/vorflux/gboardai/AiWritingTools;
.super Ljava/lang/Object;
.source "AiWritingTools.java"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static buildPrompt(Landroid/content/Context;)Ljava/lang/String;
    .locals 2

    .line 20
    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getPolishStyle(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    .line 21
    const-string v1, "custom"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_11

    invoke-static {p0}, Lcom/vorflux/gboardai/AiConfig;->getPolishPrompt(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 23
    :cond_11
    const-string p0, "concise"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_1c

    .line 24
    const-string p0, " Make it concise: remove repetition and unnecessary words while preserving every important fact."

    goto :goto_3f

    .line 25
    :cond_1c
    const-string p0, "formal"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_27

    .line 26
    const-string p0, " Use a formal, respectful tone suitable for official communication."

    goto :goto_3f

    .line 27
    :cond_27
    const-string p0, "natural"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_32

    .line 28
    const-string p0, " Use natural, conversational wording appropriate for a fluent native speaker."

    goto :goto_3f

    .line 29
    :cond_32
    const-string p0, "professional"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_3d

    .line 30
    const-string p0, " Use precise, confident, professional wording suitable for workplace communication."

    goto :goto_3f

    .line 32
    :cond_3d
    const-string p0, ""

    .line 34
    :goto_3f
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Polish the user\'s writing in the same language. Improve clarity, fluency, grammar, and naturalness without changing meaning. Preserve formatting, line breaks, emoji, names, URLs, numbers, and placeholders. Return only the polished text."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static polish(Landroid/content/Context;Ljava/lang/String;)Ljava/util/concurrent/Future;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/concurrent/Future<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 10
    new-instance v0, Ljava/util/concurrent/FutureTask;

    new-instance v1, Lcom/vorflux/gboardai/AiWritingTools$1;

    invoke-direct {v1, p0, p1}, Lcom/vorflux/gboardai/AiWritingTools$1;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/util/concurrent/FutureTask;-><init>(Ljava/util/concurrent/Callable;)V

    .line 15
    new-instance p0, Ljava/lang/Thread;

    const-string p1, "GboardAI-writing-tools"

    invoke-direct {p0, v0, p1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/lang/Thread;->start()V

    .line 16
    return-object v0
.end method
