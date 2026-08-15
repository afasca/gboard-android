#!/usr/bin/env python3
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
client = (root / "patch/src/com/vorflux/gboardai/OpenAiClient.java").read_text()
config = (root / "patch/src/com/vorflux/gboardai/AiConfig.java").read_text()
settings = (root / "patch/src/com/vorflux/gboardai/AiSettingsDialog.java").read_text()
writing = (root / "patch/src/com/vorflux/gboardai/AiWritingTools.java").read_text()
provider = (root / "patch/smali/com/vorflux/gboardai/AiTranslateProvider.smali").read_text()
task = (root / "patch/smali/com/vorflux/gboardai/AiTranslateTask.smali").read_text()
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
assert 'return TextUtils.isEmpty(base) ? "" : prefix + base;' in config
assert '"manual_model_"' in config
assert 'public static boolean isManualModel' in config
assert 'public static void setManualModel' in config
assert 'boolean manual = AiConfig.isManualModel(context);' in client
assert 'manual ? AiConfig.getManualModel(context) : AiConfig.getCachedModel(context)' in client
assert 'public static List<String> listModels' in client
assert '手动选择的模型' in client and '切回自动模式' in client

# AlertDialog uses one content panel for message or list. A picker that calls
# both setMessage() and setSingleChoiceItems() silently hides every model row.
def method_body(text, signature, terminator):
    start = text.index(signature)
    end = text.index(terminator, start)
    return text[start:end]

picker_java = method_body(settings, 'private static void showModelPicker', '    private static String modeSummary')
picker_smali = method_body((root / 'patch/smali/com/vorflux/gboardai/AiSettingsDialog.smali').read_text(),
                           '.method private static showModelPicker', '.end method')
assert '.setSingleChoiceItems(choices, selected' in picker_java
assert '.setMessage(' not in picker_java
assert '->setSingleChoiceItems(' in picker_smali
assert '->setMessage(' not in picker_smali

# Translation prompt privacy, defaults, and literal placeholder substitution.
assert 'DEFAULT_TRANSLATION_PROMPT' in config
assert '"{source}"' in config and '"{target}"' in config
assert '.replace("{source}", source == null ? "auto" : source)' in config
assert '.replace("{target}", target == null ? "" : target)' in config
assert 'getSharedPreferences(PREFS, Context.MODE_PRIVATE)' in config
assert 'AiConfig.formatTranslationPrompt(context, source, target)' in client
for secret in ('System.out', 'Log.', 'println(', 'printStackTrace'):
    assert secret not in client and secret not in config
assert '恢复默认翻译提示词' in settings
assert 'translationPrompt.setText(AiConfig.DEFAULT_TRANSLATION_PROMPT)' in settings

# Debounce presets/default and lifecycle/generation guards.
for value in (300, 500, 800, 1200, 2000):
    assert str(value) in config and str(value) in settings
assert 'getInt("translation_debounce_ms", 800)' in config
assert 'default:\n                return 800;' in config
assert '.field private pending:Ljava/lang/Runnable;' in provider
assert 'Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V' in provider
assert 'Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z' in provider
assert 'Lcom/vorflux/gboardai/AiConfig;->getDebounceMs(Landroid/content/Context;)I' in provider
assert 'add-int/lit8 v1, v1, 0x1' in provider
assert '.method public static access$dispatch' in provider
assert '.method public static access$valid' in provider
assert provider.count('monitor-enter p0') >= 2
assert 'iget-boolean v1, p1, Lacie;->e:Z' in provider
health = provider[provider.index('iget-boolean v1, p1, Lacie;->e:Z'):provider.index(':user_request')]
assert 'removeCallbacks' not in health and 'generation' not in health
assert '.implements Ljava/lang/Runnable;' in task
assert 'access$dispatch' in task and 'OpenAiClient;->translate' in task
assert 'Landroid/text/TextUtils;->isEmpty' in translate_callback
assert 'const/4 v1, 0x1' in translate_callback
assert 'const/4 v1, 0x4' not in translate_callback

# Visible native translation loading state, terminal/cancel cleanup, and translating announcement.
assert 'def patch_translation_progress' in patcher
assert 'Lcom/google/android/apps/inputmethod/libs/translate/TranslateKeyboard;->a(I)V' in patcher
assert ':vorflux_progress_started' in patcher
assert ':vorflux_progress_cleared' in patcher
assert ':vorflux_input_progress_cleared' in patcher
assert ':vorflux_stop_progress_cleared' in patcher
assert '0x7f140d8c' in patcher

# Polish replaces the fixed power-key microphone while the native voice access
# point remains in the customizable reserve list. The real click uses the
# embedded Runnable; attachment keeps the original native lifecycle event.
assert 'def patch_always_available_proofread' not in patcher
assert 'def patch_ai_polish_entry' in patcher
assert '.method public static b(ZZ)Z' not in patcher
assert 'def patch_ai_polish_click' in patcher
assert 'smali_classes2/wsb.smali' in patcher
assert 'Lakhf;->g:Lakhf;' in patcher
assert 'Lwtz;->f(Lajkj;Laodi;ZLakhf;Ljava/util/function/Consumer;)V' in patcher
assert 'def patch_power_key_polish_default' in patcher
assert 'smali/agxe.smali' in patcher
assert 'const v0, 0x7f1404b3' in patcher
assert 'const-string v1, "voice"' in patcher
assert 'Lanxc;->t(ILjava/lang/String;)V' in patcher
assert 'def patch_voice_reserve_entry' in patcher
assert 'smali/shb.smali' in patcher
assert 'native voice fixed-holder default metadata' in patcher
assert 'def patch_toolbar_jarvis_persistence' not in patcher
assert 'smali/agpc.smali' not in patcher
assert 'smali/wqp.smali' not in patcher
assert 'smali/wgw.smali' not in patcher
assert 'AI polish access point module feature gate' in patcher
assert 'AI polish unused Jarvis helper dependency' in patcher
assert 'AI writing tools module feature gate' in patcher
assert 'AI writing tools unused Jarvis helper dependency' in patcher
assert 'const-string v1, "AI 润色"' in patcher
assert 'const v0, 0x7f1406b9' in patcher
assert 'const v0, 0x7f0804cc' in patcher
assert 'def patch_polish_state_eligibility' in patcher
assert 'instance-of v1, p0, Lwsc;' in patcher
assert ':vorflux_polish_original_gate' in patcher
assert 'iget-boolean v1, p0, Lwok;->k:Z' not in patcher
assert '.implements Lbazc;' in future
for style in ('standard', 'concise', 'formal', 'natural', 'professional', 'custom'):
    assert f'"{style}"' in settings
for style in ('concise', 'formal', 'natural', 'professional', 'custom'):
    assert f'"{style}"' in writing
for label in ('标准润色', '简洁', '正式', '自然/口语', '专业', '自定义'):
    assert label in settings
assert 'if ("custom".equals(style)) return AiConfig.getPolishPrompt(context);' in writing
assert 'AiConfig.DEFAULT_POLISH_PROMPT + instruction' in writing
assert '恢复默认润色提示词' in settings
assert 'polishPrompt.setText(AiConfig.DEFAULT_POLISH_PROMPT)' in settings

# Generated smali is present for all D8-generated inner/synthetic classes.
config_smali = (root / "patch/smali/com/vorflux/gboardai/AiConfig.smali").read_text()
client_smali = (root / "patch/smali/com/vorflux/gboardai/OpenAiClient.smali").read_text()
settings_smali = (root / "patch/smali/com/vorflux/gboardai/AiSettingsDialog.smali").read_text()
assert '.method public static getTranslationPrompt' in config_smali
assert '.method public static formatTranslationPrompt' in config_smali
assert '.method public static getPolishStyle' in config_smali
assert '.method public static getDebounceMs' in config_smali
assert 'Landroid/app/AlertDialog$Builder;->setSingleChoiceItems' in settings_smali
for index in range(8):
    assert (root / f"patch/smali/com/vorflux/gboardai/AiSettingsDialog$$ExternalSyntheticLambda{index}.smali").is_file()

assert 'Lcom/vorflux/gboardai/AiTranslateProvider;' in patcher
translation_settings_patch = patcher[patcher.index('def patch_translation_settings'):patcher.index('def patch_always_reachable_ai_settings')]
preferences_patch = patcher[patcher.index('def patch_always_reachable_ai_settings'):patcher.index('def patch_polish_state_eligibility')]
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
assert 'MYBOARD_VERSION_CODE = 175894496' in split_patcher
assert 'UPSTREAM_VERSION_NAME = "17.8.3.939743344-beta-arm64-v8a"' in split_patcher
assert 'MYBOARD_VERSION_NAME = "17.8.5.939743346-beta-arm64-v8a"' in split_patcher
assert 'set_app_version' in split_patcher
assert 'remove-required-split.py' in builder
assert 'apply-coexistence-package.py' in builder
assert 'fused-gboard-安卓.apk' in builder
assert 'EXPECTED_INPUT_SHA256="f06d8e42131a3feb7a05e1e42244af43059a67899bf1fa958290f18d8106dc5a"' in builder
assert 'EXPECTED_INPUT_CERT_SHA256="f0fd6c5b410f25cb25c3b53346c8972fae30f8ee7411df910480ad6b2d60db83"' in builder
assert 'Signer #1 certificate SHA-256 digest' not in builder
assert 'certificate SHA-256 digest: $EXPECTED_INPUT_CERT_SHA256$' in builder
assert '"$ZIPALIGN" -P 16 -f 4' in builder
assert '"$ZIPALIGN" -c -P 16 4' in builder
assert 'verify-built-apk.sh' in builder
assert 'cannot be regenerated' in builder
assert 'NEW_PACKAGE = "com.vorflux.gboard.inputmethod.latin"' in coexist_patcher
assert 'EXPECTED_MANIFEST_UTF16 = 15' in coexist_patcher
assert 'EXPECTED_RESOURCES_UTF16 = 1' in coexist_patcher
assert 'SMALI_REPLACEMENTS' in coexist_patcher
assert 'AllFlags.smali' in coexist_patcher
assert 'official backend namespace' in coexist_patcher
assert 'LauncherActivity;->b(Z)V' in coexist_patcher
assert 'replace_utf8_string_pool_entry' in coexist_patcher
assert 'find_unique_utf8_pool_string(data, "Gboard")' in coexist_patcher
assert not re.search(r'sk-[A-Za-z0-9]{16,}', ''.join(p.read_text(errors='ignore') for p in (root/'patch').rglob('*') if p.is_file()))
print('static contract checks passed')
