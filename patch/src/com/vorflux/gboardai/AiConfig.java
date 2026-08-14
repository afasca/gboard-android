package com.vorflux.gboardai;

import android.content.Context;
import android.content.SharedPreferences;
import android.text.TextUtils;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.KeyStore;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import android.security.keystore.KeyGenParameterSpec;
import android.security.keystore.KeyProperties;
import android.util.Base64;

public final class AiConfig {
    private static final String PREFS = "gboard_ai_private";
    private static final String KEY_ALIAS = "gboard_ai_openai_key";
    private static final String DEFAULT_BASE = "https://api.openai.com/v1";

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
        if (TextUtils.isEmpty(normalized)) throw new IllegalStateException("API 地址无效，请在 Gboard 设置中填写有效的 HTTPS 地址");
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

    public static String getCachedModel(Context context) {
        String base = normalizeBaseUrl(getStoredBaseUrl(context));
        if (TextUtils.isEmpty(base)) return "";
        String key = Integer.toHexString(base.hashCode());
        String value = prefs(context).getString("model_" + key, "");
        return value == null ? "" : value;
    }

    public static void setCachedModel(Context context, String model) {
        String key = Integer.toHexString(getBaseUrl(context).hashCode());
        prefs(context).edit().putString("model_" + key, model == null ? "" : model).apply();
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
