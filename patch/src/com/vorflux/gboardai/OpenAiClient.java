package com.vorflux.gboardai;

import android.content.Context;
import android.text.TextUtils;
import org.json.JSONArray;
import org.json.JSONObject;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public final class OpenAiClient {
    private OpenAiClient() {}

    public interface Callback { void onComplete(String result, String error); }

    public static void translate(Context context, String text, String source, String target, Callback callback) {
        completeAsync(context, AiConfig.formatTranslationPrompt(context, source, target), text, callback);
    }

    public static void polish(Context context, String text, Callback callback) {
        completeAsync(context, AiConfig.getPolishPrompt(context), text, callback);
    }

    public static void completeAsync(final Context context, final String system, final String text, final Callback callback) {
        new Thread(new Runnable() {
            @Override public void run() {
                String result = null;
                String error = null;
                try { result = complete(context, system, text); }
                catch (Exception e) { error = safeError(e); }
                final String finalResult = result;
                final String finalError = error;
                new android.os.Handler(android.os.Looper.getMainLooper()).post(new Runnable() {
                    @Override public void run() { callback.onComplete(finalResult, finalError); }
                });
            }
        }, "GboardAI").start();
    }

    public static String complete(Context context, String system, String text) throws Exception {
        String key = AiConfig.getApiKey(context);
        if (TextUtils.isEmpty(key)) throw new IllegalStateException("请先在 Gboard 设置中配置 OpenAI API Key");
        boolean manual = AiConfig.isManualModel(context);
        String model = manual ? AiConfig.getManualModel(context) : AiConfig.getCachedModel(context);
        if (TextUtils.isEmpty(model)) {
            model = discoverModel(context, key);
            AiConfig.setCachedModel(context, model);
        }
        JSONObject payload = new JSONObject();
        payload.put("model", model);
        payload.put("temperature", 0.2d);
        payload.put("stream", false);
        JSONArray messages = new JSONArray();
        messages.put(new JSONObject().put("role", "system").put("content", system));
        messages.put(new JSONObject().put("role", "user").put("content", text));
        payload.put("messages", messages);
        JSONObject response;
        try {
            response = request(context, "POST", "/chat/completions", key, payload);
        } catch (HttpStatusException failure) {
            if (!failure.isMissingModel()) throw failure;
            if (manual) {
                throw new IllegalStateException("手动选择的模型“" + model + "”不可用。请在 MyBoard AI 设置中选择其他模型或切回自动模式。");
            }
            AiConfig.setCachedModel(context, "");
            model = discoverModel(context, key);
            AiConfig.setCachedModel(context, model);
            payload.put("model", model);
            response = request(context, "POST", "/chat/completions", key, payload);
        }
        JSONArray choices = response.optJSONArray("choices");
        if (choices == null || choices.length() == 0) throw new IllegalStateException("模型未返回内容");
        String content = choices.getJSONObject(0).getJSONObject("message").optString("content", "");
        if (TextUtils.isEmpty(content.trim())) throw new IllegalStateException("模型返回了空内容");
        return content;
    }

    public static List<String> listModels(Context context, String key) throws Exception {
        JSONObject response = request(context, "GET", "/models", key, null);
        JSONArray data = response.optJSONArray("data");
        if (data == null) throw new IllegalStateException("/models 未返回模型列表");
        List<String> candidates = new ArrayList<String>();
        for (int i = 0; i < data.length(); i++) {
            String id = data.optJSONObject(i) == null ? "" : data.optJSONObject(i).optString("id", "");
            String lower = id.toLowerCase(java.util.Locale.ROOT);
            if (TextUtils.isEmpty(id) || lower.contains("embed") || lower.contains("whisper") ||
                    lower.contains("tts") || lower.contains("audio") || lower.contains("image") ||
                    lower.contains("dall-e") || lower.contains("moderation") || lower.contains("rerank") ||
                    lower.contains("transcri")) continue;
            candidates.add(id);
        }
        if (candidates.isEmpty()) throw new IllegalStateException("没有可用的文本生成模型");
        Collections.sort(candidates, new Comparator<String>() {
            @Override public int compare(String a, String b) {
                int scoreA = score(a); int scoreB = score(b);
                if (scoreA != scoreB) return scoreB - scoreA;
                return a.compareToIgnoreCase(b);
            }
        });
        return candidates;
    }

    public static String discoverModel(Context context, String key) throws Exception {
        return listModels(context, key).get(0);
    }

    private static int score(String value) {
        String s = value.toLowerCase(java.util.Locale.ROOT);
        int score = 0;
        if (s.contains("gpt-4o-mini")) score += 1000;
        else if (s.contains("gpt-4.1-mini")) score += 950;
        else if (s.contains("gpt-4o")) score += 900;
        else if (s.contains("gpt-4.1")) score += 850;
        else if (s.contains("gemini") || s.contains("claude") || s.contains("deepseek") || s.contains("qwen")) score += 700;
        if (s.contains("chat") || s.contains("instruct")) score += 100;
        if (s.contains("latest")) score -= 150;
        if (s.contains("preview") || s.contains("experimental")) score -= 300;
        return score;
    }

    private static JSONObject request(Context context, String method, String path, String key, JSONObject body) throws Exception {
        HttpURLConnection connection = (HttpURLConnection) new URL(AiConfig.getBaseUrl(context) + path).openConnection();
        try {
            connection.setRequestMethod(method);
            connection.setConnectTimeout(15000);
            connection.setReadTimeout(60000);
            connection.setRequestProperty("Authorization", "Bearer " + key);
            connection.setRequestProperty("Accept", "application/json");
            if (body != null) {
                connection.setDoOutput(true);
                connection.setRequestProperty("Content-Type", "application/json; charset=utf-8");
                byte[] bytes = body.toString().getBytes(StandardCharsets.UTF_8);
                OutputStream output = connection.getOutputStream();
                try { output.write(bytes); } finally { output.close(); }
            }
            int code = connection.getResponseCode();
            InputStream input = code >= 200 && code < 300 ? connection.getInputStream() : connection.getErrorStream();
            String responseText = readAll(input);
            if (code < 200 || code >= 300) {
                String message = "HTTP " + code;
                try {
                    JSONObject error = new JSONObject(responseText).optJSONObject("error");
                    if (error != null && !TextUtils.isEmpty(error.optString("message"))) message += ": " + error.optString("message");
                } catch (Exception ignored) {}
                throw new HttpStatusException(code, message);
            }
            return new JSONObject(responseText);
        } finally {
            connection.disconnect();
        }
    }

    private static final class HttpStatusException extends IllegalStateException {
        private final int code;
        private static final long serialVersionUID = 1L;
        HttpStatusException(int code, String message) { super(message); this.code = code; }
        boolean isMissingModel() {
            String message = getMessage();
            return code == 404 || (code == 400 && message != null && message.toLowerCase(java.util.Locale.ROOT).contains("model"));
        }
    }

    private static String readAll(InputStream input) throws Exception {
        if (input == null) return "";
        BufferedReader reader = new BufferedReader(new InputStreamReader(input, StandardCharsets.UTF_8));
        StringBuilder out = new StringBuilder(); String line;
        while ((line = reader.readLine()) != null) out.append(line).append('\n');
        reader.close(); return out.toString();
    }

    private static String safeError(Exception error) {
        String message = error.getMessage();
        return TextUtils.isEmpty(message) ? error.getClass().getSimpleName() : message;
    }
}
