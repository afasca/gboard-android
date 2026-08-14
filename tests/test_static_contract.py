#!/usr/bin/env python3
from pathlib import Path
import re
root = Path(__file__).resolve().parents[1]
client = (root / "patch/src/com/vorflux/gboardai/OpenAiClient.java").read_text()
config = (root / "patch/src/com/vorflux/gboardai/AiConfig.java").read_text()
provider = (root / "patch/smali/com/vorflux/gboardai/AiTranslateProvider.smali").read_text()
future = (root / "patch/smali/com/vorflux/gboardai/AiPolishFuture.smali").read_text()
translate_callback = (root / "patch/smali/com/vorflux/gboardai/AiTranslateCallback.smali").read_text()
patcher = (root / "scripts/apply-smali-patches.py").read_text()
split_patcher = (root / "scripts/remove-required-split.py").read_text()
coexist_patcher = (root / "scripts/apply-coexistence-package.py").read_text()
builder = (root / "scripts/build-ai-gboard.sh").read_text()
assert '"GET", "/models"' in client
assert '"POST", "/chat/completions"' in client
for blocked in ("embed", "whisper", "tts", "audio", "image", "moderation", "rerank"):
    assert blocked in client
assert 'gpt-4o-mini' in client and 'score += 1000' in client
assert 's.contains("latest")) score -= 150' in client
assert 's.contains("preview") || s.contains("experimental")) score -= 300' in client
assert 'if (TextUtils.isEmpty(content.trim()))' in client
assert 'AiConfig.setCachedModel(context, "")' in client
assert 'finally {\n            connection.disconnect();' in client
assert 'AndroidKeyStore' in config and 'AES/GCM/NoPadding' in config
assert '.setKeySize(256)' in config
assert '"https".equalsIgnoreCase(parsed.getProtocol())' in config
assert 'public static boolean setBaseUrl' in config
assert 'return false;' in config
assert 'public static String getStoredBaseUrl' in config
assert 'String base = normalizeBaseUrl(getStoredBaseUrl(context));' in config
assert 'TextUtils.isEmpty(base) ? ""' in config
assert 'if (TextUtils.isEmpty(key)) return "";' in config
assert 'return TextUtils.isEmpty(base) ? "" : prefix + base;' in config
assert 'putString("model_" + getBaseUrl(context)' in config
assert '"manual_model_"' in config
assert 'public static boolean isManualModel' in config
assert 'public static void setManualModel' in config
assert 'boolean manual = AiConfig.isManualModel(context);' in client
assert 'manual ? AiConfig.getManualModel(context) : AiConfig.getCachedModel(context)' in client
assert 'public static List<String> listModels' in client
assert 'if (manual) {' in client
assert '手动选择的模型' in client and '切回自动模式' in client
settings = (root / "patch/src/com/vorflux/gboardai/AiSettingsDialog.java").read_text()
config_smali = (root / "patch/smali/com/vorflux/gboardai/AiConfig.smali").read_text()
client_smali = (root / "patch/smali/com/vorflux/gboardai/OpenAiClient.smali").read_text()
settings_smali = (root / "patch/smali/com/vorflux/gboardai/AiSettingsDialog.smali").read_text()
settings_picker_smali = (root / "patch/smali/com/vorflux/gboardai/AiSettingsDialog$2.smali").read_text()
assert '.method public static getManualModel(Landroid/content/Context;)Ljava/lang/String;' in config_smali
assert '.method public static isManualModel(Landroid/content/Context;)Z' in config_smali
assert '.method public static setManualModel(Landroid/content/Context;Ljava/lang/String;)V' in config_smali
assert 'const-string v0, "manual_model_"' in config_smali
assert '.method public static listModels(Landroid/content/Context;Ljava/lang/String;)Ljava/util/List;' in client_smali
assert 'Lcom/vorflux/gboardai/AiConfig;->isManualModel(Landroid/content/Context;)Z' in client_smali
assert 'Lcom/vorflux/gboardai/AiConfig;->getManualModel(Landroid/content/Context;)Ljava/lang/String;' in client_smali
assert 'Landroid/app/AlertDialog$Builder;->setSingleChoiceItems' in settings_smali
assert 'Lcom/vorflux/gboardai/AiConfig;->setManualModel' in settings_picker_smali
assert 'setText(AiConfig.getStoredBaseUrl(context))' in settings
assert 'setTitle("MyBoard AI · OpenAI 兼容设置")' in settings
assert 'setError("请输入有效的 HTTPS API 地址")' in settings
assert 'OpenAiClient.listModels(context, apiKey)' in settings
assert 'setSingleChoiceItems(choices, checked' in settings
assert 'choices[0] = "自动选择（推荐）"' in settings
assert 'AiConfig.setManualModel(context, "")' in settings
assert 'AiConfig.setManualModel(context, selected)' in settings
assert '当前模式：手动' in settings and '当前模式：自动' in settings
assert '.implements Lacgc;' in provider
assert 'sget-object v2, Laciy;->a:Lazfk;' in provider
assert 'sget-object v2, Laciy;->b:Lazfk;' in provider
assert 'Laciy;->d(Landroid/content/Context;Ljava/util/Locale;)Ljava/lang/String;' in provider
assert 'Laciy;->b(Ljava/lang/String;)Ljava/lang/String;' in provider
assert 'Laciy;->c(Ljava/lang/String;)Ljava/lang/String;' in provider
assert 'Laqkl;->a(Ljava/lang/String;Ljava/util/Locale;)Ljava/lang/String;' in provider
assert 'Laqkh;->n(Landroid/content/Context;Ljava/util/Locale;)Ljava/lang/CharSequence;' not in provider
assert '.implements Lbazc;' in future
assert 'const/4 v1, 0x2' in translate_callback
assert 'Lakhf;->g:Lakhf;' in patcher
assert 'const/4 v5, 0x1' in patcher
assert 'enable_writing_tools_v2_on_toolbar' in patcher
assert 'Lcom/vorflux/gboardai/AiTranslateProvider;' in patcher
translation_settings_patch = patcher[patcher.index('def patch_translation_settings'):patcher.index('def patch_always_reachable_ai_settings')]
preferences_patch = patcher[patcher.index('def patch_always_reachable_ai_settings'):patcher.index('def patch_writing_tools_toolbar_flag')]
assert 'AutoTranslatePreferenceFragment.smali' in translation_settings_patch
assert 'PreferencesSettingsFragment.smali' in preferences_patch
for settings_patch in (translation_settings_patch, preferences_patch):
    assert 'MyBoard AI · OpenAI 兼容设置' in settings_patch
    assert 'gboard_ai_settings' in settings_patch
    assert 'PreferenceGroup;->l(Ljava/lang/CharSequence;)Landroidx/preference/Preference;' in settings_patch
    assert 'if-nez v1, :ai_settings_done' in settings_patch
assert 'auto_show_translate' not in preferences_patch
assert 'settings_header_translate' not in preferences_patch
assert 'patch_development_certificate' in patcher
assert '0x72t' in patcher and '-0x15t' in patcher
assert 'EXPECTED_CERT_SHA256="72f35793e9f17aba292fe6dd1607eca6b783cf779ca52b1561f03e5bc411ebeb"' in builder
assert 'REQUIRED_SPLIT_TYPES_ID = 0x0101064E' in split_patcher
assert 'MIN_SDK_VERSION = 32' in split_patcher
assert 'UPSTREAM_VERSION_CODE = 175894494' in split_patcher
assert 'MYBOARD_VERSION_CODE = 175894495' in split_patcher
assert 'UPSTREAM_VERSION_NAME = "17.8.3.939743344-beta-arm64-v8a"' in split_patcher
assert 'MYBOARD_VERSION_NAME = "17.8.4.939743345-beta-arm64-v8a"' in split_patcher
assert 'set_app_version' in split_patcher
assert 'MyBoard-AI-v6' not in split_patcher
assert 'remove-required-split.py' in builder
assert 'apply-coexistence-package.py' in builder
assert 'fused-gboard-安卓.apk' in builder
assert 'MyBoard-AI-v6.apk' in builder
assert 'EXPECTED_INPUT_SHA256="f06d8e42131a3feb7a05e1e42244af43059a67899bf1fa958290f18d8106dc5a"' in builder
assert 'EXPECTED_INPUT_CERT_SHA256="f0fd6c5b410f25cb25c3b53346c8972fae30f8ee7411df910480ad6b2d60db83"' in builder
assert '"$ZIPALIGN" -P 16 -f 4' in builder
assert '"$ZIPALIGN" -c -P 16 4' in builder
assert 'verify-built-apk.sh' in builder
assert 'INPUT_APK="$INPUT_APK"' in builder
assert 'cannot be regenerated' in builder
assert 'NEW_PACKAGE = "com.vorflux.gboard.inputmethod.latin"' in coexist_patcher
assert 'EXPECTED_MANIFEST_UTF16 = 15' in coexist_patcher
assert 'EXPECTED_RESOURCES_UTF16 = 1' in coexist_patcher
assert 'EXPECTED_RESOURCES_UTF8' not in coexist_patcher
assert 'SMALI_REPLACEMENTS' in coexist_patcher
assert 'AllFlags.smali' in coexist_patcher
assert 'official backend namespace' in coexist_patcher
assert 'LauncherActivity;->b(Z)V' in coexist_patcher
assert 'replace_utf8_string_pool_entry' in coexist_patcher
assert 'find_unique_utf8_pool_string(data, "Gboard")' in coexist_patcher
assert 'NAMESPACE_PAYLOADS' not in coexist_patcher
assert 'com_vorflux_gboard_inputmethod_latin_package_metadata.binarypb' not in coexist_patcher
assert not re.search(r'sk-[A-Za-z0-9]{16,}', ''.join(p.read_text(errors='ignore') for p in (root/'patch').rglob('*') if p.is_file()))
print('static contract checks passed')
