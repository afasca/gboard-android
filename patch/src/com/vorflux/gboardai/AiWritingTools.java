package com.vorflux.gboardai;

import android.content.Context;
import java.util.concurrent.Future;

public final class AiWritingTools {
    private AiWritingTools() {}

    public static Future<String> polish(final Context context, final String text) {
        java.util.concurrent.FutureTask<String> task = new java.util.concurrent.FutureTask<String>(new java.util.concurrent.Callable<String>() {
            @Override public String call() throws Exception {
                return OpenAiClient.complete(context, buildPrompt(context), text);
            }
        });
        new Thread(task, "GboardAI-writing-tools").start();
        return task;
    }

    static String buildPrompt(Context context) {
        String style = AiConfig.getPolishStyle(context);
        if ("custom".equals(style)) return AiConfig.getPolishPrompt(context);
        String instruction;
        if ("concise".equals(style)) {
            instruction = " Make it concise: remove repetition and unnecessary words while preserving every important fact.";
        } else if ("formal".equals(style)) {
            instruction = " Use a formal, respectful tone suitable for official communication.";
        } else if ("natural".equals(style)) {
            instruction = " Use natural, conversational wording appropriate for a fluent native speaker.";
        } else if ("professional".equals(style)) {
            instruction = " Use precise, confident, professional wording suitable for workplace communication.";
        } else {
            instruction = "";
        }
        return AiConfig.DEFAULT_POLISH_PROMPT + instruction;
    }
}
