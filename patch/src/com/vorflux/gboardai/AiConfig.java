package com.vorflux.gboardai;

import android.content.Context;
import android.content.SharedPreferences;
import android.security.keystore.KeyGenParameterSpec;
import android.security.keystore.KeyProperties;
import android.text.TextUtils;
import android.util.Base64;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.KeyStore;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;

public final class AiConfig {
    private static final String PREFS = "gboard_ai_private";
    private static final String KEY_ALIAS = "gboard_ai_openai_key";
    private static final String DEFAULT_BASE = "https://api.openai.com/v1";
    public static final String DEFAULT_TRANSLATION_PROMPT =
            "Translate the text from {source} to {target}. Preserve meaning, tone, formatting, line breaks, emoji, names, URLs, numbers, and placeholders. Do not add explanations or invent facts. Return only the translated text.";
    public static final String DEFAULT_POLISH_PROMPT =
            "Polish the user's writing in the same language. Improve clarity, fluency, grammar, and naturalness without changing meaning. Preserve formatting, line breaks, emoji, names, URLs, numbers, and placeholders. Return only the polished text.";

    private AiConfig() {}

    private static SharedPreferences prefs(Context context) {
        return context.getSharedPreferences(PREFS, Context.MODE_PRIVATE);
    }

    public static String normalizeBaseUrl(String value) {
        if (value == null) return "";
        value = value.trim();
        while (value.endsWith("/")) value = value.substring(0, value.length() - 1);
        try {
            URL parsed = new URL(value);
            if (!"https".equalsIgnoreCase(parsed.getProtocol()) || TextUtils.isEmpty(parsed.getHost()) ||
                    parsed.getUserInfo() != null || parsed.getQuery() != null || parsed.getRef() != null) return "";
        } catch (Exception ignored) {
            return "";
        }
        if (!value.endsWith("/v1")) value += "/v1";
        return value;
    }

    public static String getStoredBaseUrl(Context context) {
        String stored = prefs(context).getString("base_url", DEFAULT_BASE);
        return stored == null ? DEFAULT_BASE : stored;
    }

    public static String getBaseUrl(Context context) {
        String normalized = normalizeBaseUrl(getStoredBaseUrl(context));
        if (TextUtils.isEmpty(normalized)) throw new IllegalStateException("API 地址无效，请在 MyBoard 设置中填写有效的 HTTPS 地址");
        return normalized;
    }

    public static boolean setBaseUrl(Context context, String value) {
        String normalized = normalizeBaseUrl(value);
        if (TextUtils.isEmpty(normalized)) return false;
        prefs(context).edit().putString("base_url", normalized).apply();
        return true;
    }

    public static String getApiKey(Context context) {
        String encrypted = prefs(context).getString("api_key", "");
        if (TextUtils.isEmpty(encrypted)) return "";
        try {
            String[] parts = encrypted.split("\\.", 2);
            if (parts.length != 2) return "";
            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            cipher.init(Cipher.DECRYPT_MODE, getOrCreateKey(), new GCMParameterSpec(128, Base64.decode(parts[0], Base64.NO_WRAP)));
            return new String(cipher.doFinal(Base64.decode(parts[1], Base64.NO_WRAP)), StandardCharsets.UTF_8);
        } catch (Exception ignored) {
            return "";
        }
    }

    public static void setApiKey(Context context, String value) {
        if (TextUtils.isEmpty(value)) {
            prefs(context).edit().remove("api_key").apply();
            return;
        }
        try {
            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            cipher.init(Cipher.ENCRYPT_MODE, getOrCreateKey());
            String encrypted = Base64.encodeToString(cipher.getIV(), Base64.NO_WRAP) + "." +
                    Base64.encodeToString(cipher.doFinal(value.trim().getBytes(StandardCharsets.UTF_8)), Base64.NO_WRAP);
            prefs(context).edit().putString("api_key", encrypted).apply();
        } catch (Exception ignored) {
            prefs(context).edit().remove("api_key").apply();
        }
    }

    private static String endpointKey(Context context, String prefix) {
        String base = normalizeBaseUrl(getStoredBaseUrl(context));
        return TextUtils.isEmpty(base) ? "" : prefix + base;
    }

    public static String getCachedModel(Context context) {
        String key = endpointKey(context, "model_");
        if (TextUtils.isEmpty(key)) return "";
        String value = prefs(context).getString(key, "");
        return value == null ? "" : value;
    }

    public static void setCachedModel(Context context, String model) {
        prefs(context).edit().putString("model_" + getBaseUrl(context), model == null ? "" : model).apply();
    }

    public static String getManualModel(Context context) {
        String key = endpointKey(context, "manual_model_");
        if (TextUtils.isEmpty(key)) return "";
        String value = prefs(context).getString(key, "");
        return value == null ? "" : value;
    }

    public static boolean isManualModel(Context context) {
        return !TextUtils.isEmpty(getManualModel(context));
    }

    public static void setManualModel(Context context, String model) {
        String value = model == null ? "" : model.trim();
        prefs(context).edit().putString(endpointKey(context, "manual_model_"), value).apply();
    }

    public static String getTranslationPrompt(Context context) {
        String value = prefs(context).getString("translation_prompt", DEFAULT_TRANSLATION_PROMPT);
        return TextUtils.isEmpty(value) ? DEFAULT_TRANSLATION_PROMPT : value;
    }

    public static void setTranslationPrompt(Context context, String value) {
        prefs(context).edit().putString("translation_prompt",
                TextUtils.isEmpty(value) ? DEFAULT_TRANSLATION_PROMPT : value.trim()).apply();
    }

    public static String formatTranslationPrompt(Context context, String source, String target) {
        return getTranslationPrompt(context)
                .replace("{source}", source == null ? "auto" : source)
                .replace("{target}", target == null ? "" : target);
    }

    public static String getPolishPrompt(Context context) {
        String value = prefs(context).getString("polish_prompt", DEFAULT_POLISH_PROMPT);
        return TextUtils.isEmpty(value) ? DEFAULT_POLISH_PROMPT : value;
    }

    public static void setPolishPrompt(Context context, String value) {
        prefs(context).edit().putString("polish_prompt",
                TextUtils.isEmpty(value) ? DEFAULT_POLISH_PROMPT : value.trim()).apply();
    }

    public static String getPolishStyle(Context context) {
        String value = prefs(context).getString("polish_style", "standard");
        return TextUtils.isEmpty(value) ? "standard" : value;
    }

    public static void setPolishStyle(Context context, String value) {
        prefs(context).edit().putString("polish_style",
                TextUtils.isEmpty(value) ? "standard" : value).apply();
    }

    public static int getDebounceMs(Context context) {
        int value = prefs(context).getInt("translation_debounce_ms", 800);
        switch (value) {
            case 300:
            case 500:
            case 800:
            case 1200:
            case 2000:
                return value;
            default:
                return 800;
        }
    }

    public static void setDebounceMs(Context context, int value) {
        switch (value) {
            case 300:
            case 500:
            case 800:
            case 1200:
            case 2000:
                prefs(context).edit().putInt("translation_debounce_ms", value).apply();
                break;
            default:
                prefs(context).edit().putInt("translation_debounce_ms", 800).apply();
        }
    }

    private static SecretKey getOrCreateKey() throws Exception {
        KeyStore store = KeyStore.getInstance("AndroidKeyStore");
        store.load(null);
        if (!store.containsAlias(KEY_ALIAS)) {
            KeyGenerator generator = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore");
            generator.init(new KeyGenParameterSpec.Builder(KEY_ALIAS,
                    KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT)
                    .setKeySize(256)
                    .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                    .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                    .setRandomizedEncryptionRequired(true)
                    .build());
            generator.generateKey();
        }
        return ((KeyStore.SecretKeyEntry) store.getEntry(KEY_ALIAS, null)).getSecretKey();
    }
}
