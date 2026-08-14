package com.vorflux.gboardai;

import android.content.Context;
import java.util.concurrent.Future;

public final class AiWritingTools {
    private AiWritingTools() {}

    public static Future<String> polish(final Context context, final String text) {
        java.util.concurrent.FutureTask<String> task = new java.util.concurrent.FutureTask<String>(new java.util.concurrent.Callable<String>() {
            @Override public String call() throws Exception {
                return OpenAiClient.complete(context,
                        "Polish the user's writing in the same language. Improve clarity, fluency, grammar, and naturalness without changing meaning. Preserve formatting and emoji. Return only the polished text.",
                        text);
            }
        });
        new Thread(task, "GboardAI-writing-tools").start();
        return task;
    }
}
