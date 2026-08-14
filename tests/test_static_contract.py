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
assert 'if (TextUtils.isEmpty(base)) return "";' in config
settings = (root / "patch/src/com/vorflux/gboardai/AiSettingsDialog.java").read_text()
assert 'setText(AiConfig.getStoredBaseUrl(context))' in settings
assert 'setError("请输入有效的 HTTPS API 地址")' in settings
assert '.implements Lacgc;' in provider
assert 'sget-object v2, Laciy;->a:Lazfk;' in provider
assert 'sget-object v2, Laciy;->b:Lazfk;' in provider
assert '.implements Lbazc;' in future
assert 'const/4 v1, 0x2' in translate_callback
assert 'Lakhf;->g:Lakhf;' in patcher
assert 'const/4 v5, 0x1' in patcher
assert 'enable_writing_tools_v2_on_toolbar' in patcher
assert 'Lcom/vorflux/gboardai/AiTranslateProvider;' in patcher
assert 'patch_development_certificate' in patcher
assert '0x72t' in patcher and '-0x15t' in patcher
assert 'EXPECTED_CERT_SHA256="72f35793e9f17aba292fe6dd1607eca6b783cf779ca52b1561f03e5bc411ebeb"' in builder
assert 'REQUIRED_SPLIT_TYPES_ID = 0x0101064E' in split_patcher
assert 'remove-required-split.py' in builder
assert not re.search(r'sk-[A-Za-z0-9]{16,}', ''.join(p.read_text(errors='ignore') for p in (root/'patch').rglob('*') if p.is_file()))
print('static contract checks passed')
