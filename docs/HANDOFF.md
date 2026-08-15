# MyBoard AI engineering handoff

Last updated: 2026-08-14

## Repository and collaboration state

- Repository: `https://github.com/afasca/gboard-android`
- Working branch: `vorflux/ai-translation-polish`
- Pull request: `https://github.com/afasca/gboard-android/pull/1`
- Last fully published commit before this handoff: `ca94c85 Fix AI settings and language chooser`
- The model-picker/app-version work described below is being committed as a handoff checkpoint. It is build-verified but has not received physical ARM64 UI validation.
- Do not create a second PR for this branch. Continue updating PR #1.

## Product goal

Create **MyBoard**, an independently installable Gboard-derived ARM64 keyboard that can coexist with official Gboard and adds:

1. OpenAI-compatible AI translation.
2. AI polish/rewrite.
3. Secure endpoint/API-key configuration.
4. Automatic model discovery plus manual model selection.
5. Minimal changes outside requested AI/coexistence behavior.

The visible app name is **MyBoard** and the original icon is retained.

## Current package and app metadata

- Package: `com.vorflux.gboard.inputmethod.latin`
- Current app version code: `175894496`
- Current app version name: `17.8.5.939743346-beta-arm64-v8a`
- minSdk: 32
- targetSdk: 37
- ABI: `arm64-v8a` only
- Development signer SHA-256: `72f35793e9f17aba292fe6dd1607eca6b783cf779ca52b1561f03e5bc411ebeb`
- Input fused APK SHA-256: `f06d8e42131a3feb7a05e1e42244af43059a67899bf1fa958290f18d8106dc5a`
- Input Google signer SHA-256: `f0fd6c5b410f25cb25c3b53346c8972fae30f8ee7411df910480ad6b2d60db83`

The app version uses a natural upstream-style increment. Release asset labels such as v5/v6 are not used as Android `versionName`.

## Completed and published functionality

### Coexistence

- Independent package, data directory, providers, custom permissions, and IME service identity.
- Official backend namespaces are intentionally retained where Gboard expects them.
- Development signer is added to Gboard's internal signer allowlist; the integrity check is not disabled.
- Launcher bypasses Firebase Dynamic Links for the clone.

### Complete standalone resources

The original repository APK is an incomplete Play base APK. Removing its density-split requirement alone made it installable but caused Launcher/LatinIME resource crashes. The repository now vendors `fused-gboard-安卓.apk`, which supplies the complete standalone resources.

Established closure audit:

- 8,374 compiled XML files.
- 1,050 unique drawable/mipmap IDs referenced.
- Zero missing resource IDs, configurations, or files.
- Confirmed crash IDs resolve: `0x7f08054b`, `0x7f08054c`, `0x7f080561`.

### AI translation

- `AiTranslateProvider` replaces Gboard's translation provider through `Lacgc;`.
- Source auto-detection and the original source/target language inventories are retained.
- Language maps now follow Gboard's normalized language-code and localized `String` contract. This fixed the dimmed/empty language chooser reported on-device.
- Translation requests use `POST /v1/chat/completions`.

### AI settings

The settings row is available under:

`MyBoard settings → Preferences → MyBoard AI · OpenAI 兼容设置`

It is also injected into Translate settings when that feature-gated screen exists. Both insertion points detect `gboard_ai_settings` before adding the row, preventing duplicates after resume.

Configuration includes:

- HTTPS OpenAI-compatible Base URL.
- API key stored with Android Keystore AES-256-GCM.
- `/v1/models` discovery.
- Automatic model selection by ranked filtering.
- Current checkpoint adds explicit manual model selection and a return-to-automatic option.

### AI polish

Current implementation intercepts `akhf.PROOFREAD` in `wei.B(...)`, captures selected text or the full captured text, calls `AiWritingTools.polish(...)`, and reuses Gboard's result/accept/replace/undo pipeline.

The `AI 润色` toolbar entry and six styles are implemented. The direct `wqp` registration gate and transitive `wgw` gate are removed so the existing `Lwgv.a` minors-readiness producer can initialize; `wqp` still requires that tag, and `Lwtu.J`/`Lahce.b` continue deciding readiness. The `wsc` toolbar-provider gate is bypassed only after the original editor/context eligibility checks. Physical ARM64 validation is still required for discoverability and interaction behavior.

## Current checkpoint: manual model picker

The current worktree adds:

- `OpenAiClient.listModels(...)` returning the filtered/ranked list.
- Automatic mode as default.
- A single-choice model dialog containing `自动选择（推荐）` and all compatible model IDs.
- Manual model choice scoped to the exact normalized Base URL.
- Current mode/model summary in AI settings.
- Missing manual model behavior that preserves the user's choice and returns a clear error instead of silently switching.
- Historical model-picker checkpoint used code `175894495`, name `17.8.4.939743345-beta-arm64-v8a`; the current release metadata is listed above.

Historical checkpoint artifact produced before handoff (not the current release candidate):

- Local path: `build/MyBoard-AI-v6.apk`
- Size: 82,280,945 bytes
- SHA-256: `1d14d69e10afed8730b40c2a23c7487713efb3dfa2c26705043a7f692bfff80c`

This artifact passed build/static/package verification, but it is a checkpoint rather than a user-validated release.

## Explicit unfinished user requirements

### 1. Polish discoverability and styles

The user cannot find AI polish and requests:

- A clearly discoverable polish entry.
- Several preset rewrite styles.
- A custom style/custom prompt.

Recommended design:

- Keep the existing Gboard Writing Tools integration because it preserves selection, replacement, result cards, and undo.
- Add a clearly labeled `AI 润色` access point in a toolbar/menu path that is not feature-gated, or add a dedicated action alongside the existing AI configuration entry.
- Add polish mode to `AiConfig`, scoped globally per MyBoard install:
  - `标准润色`
  - `简洁`
  - `正式`
  - `自然/口语`
  - `专业`
  - `自定义`
- Store the selected preset and custom prompt in private SharedPreferences. Do not place user prompts in logs.
- Construct the final system prompt centrally so Java reference and authoritative smali cannot drift.

### 2. Editable translation prompt

The user requests an editable translation instruction.

Recommended design:

- Add a translation prompt field to MyBoard AI settings.
- Define a safe default preserving meaning, tone, formatting, emoji, and line breaks.
- Support placeholders such as `{source}` and `{target}`; validate/substitute them before request construction.
- Provide a “restore default” action.
- Store privately; never log the prompt or translated text.

### 3. Visible translation progress

The user reports no obvious indication that translation is running.

Recommended design:

- Reuse Gboard's existing loading state when possible rather than adding a new overlay.
- Trace `AiTranslateProvider.d(Lacie; Lacgb;)` and callback state transitions into `aciv`; ensure the request immediately emits the provider/UI state that shows loading text/spinner.
- Use visible copy such as `正在翻译…` in the translation surface.
- Ensure completion/error/cancellation always clears the loading state.

### 4. Configurable pause/debounce

The user wants translation to start only after typing has paused, to avoid multiple API calls in one typing burst.

Recommended design:

- Add a setting in milliseconds, with presets such as 300/500/800/1200/2000 ms; recommended default 800 ms.
- Implement debounce at the provider boundary before `OpenAiClient.translate`, not inside HTTP handling.
- Keep one pending scheduled request per provider instance.
- On each new request: cancel the pending runnable/future, increment a generation token, and schedule the newest text.
- When a request has already started, ignore stale callbacks by generation token. If practical, add HTTP interruption/cancellation separately; callback suppression is mandatory.
- Health probes (`acie.e == true`) must remain uncharged and must not cancel a real translation request.
- `close()` must cancel pending work and invalidate callbacks.
- Display `等待输入停顿…` during debounce and `正在翻译…` after dispatch if the existing UI supports distinct states; otherwise show `正在翻译…` for both.

## Architecture and source-of-truth rules

- `patch/src/com/vorflux/gboardai/*.java` are readable reference sources.
- `patch/smali/com/vorflux/gboardai/*.smali` are authoritative packaged classes because `scripts/build-ai-gboard.sh` copies them directly into `smali_classes4`.
- Whenever Java changes, regenerate or manually synchronize all relevant smali and inner classes.
- `scripts/apply-smali-patches.py` patches original Gboard classes.
- Keep patch tools/tests executable (`100755`); Java/smali source files remain `100644`.

Important classes:

- `AiConfig`: secure endpoint/key and model-mode persistence.
- `OpenAiClient`: model listing/ranking and chat-completions requests.
- `AiSettingsDialog`: endpoint/key/model UI.
- `AiTranslateProvider`: language maps and translation provider lifecycle.
- `AiTranslateCallback`: provider callback conversion.
- `AiWritingTools`: polish request entry.
- `AiPolishFuture` / `AiPolishListener`: Writing Tools async adaptation.
- `wei.B(...)`: Proofread interception.
- `aciv.o(...)`: authoritative provider initialization.

## Model-selection behavior contract

- Model IDs containing embedding, whisper, TTS, audio, image, DALL-E, moderation, rerank, or transcription markers are filtered out.
- Ranked automatic preference currently favors GPT-4o-mini, GPT-4.1-mini, GPT-4o, GPT-4.1, then Gemini/Claude/DeepSeek/Qwen families, then chat/instruct names.
- Automatic mode caches the chosen model per normalized endpoint and rediscovers once when a missing-model error occurs.
- Manual mode is also scoped per endpoint.
- A missing manual model must not silently fall back; settings should prompt the user to choose another model or return to automatic.

## Build and verification

Required:

- Android Build Tools 35+ `zipalign` with `-P 16`.
- The existing development keystore at `build/gboard-ai.keystore` or another secured path passed via `KEYSTORE`.
- The exact signer is required because Gboard's internal allowlist is patched to that certificate.

Build:

```bash
KEYSTORE="$PWD/build/gboard-ai.keystore" \
ZIPALIGN=/var/tmp/android-build-tools-35/android-15/zipalign \
OUTPUT_APK="$PWD/build/MyBoard-AI-17.8.5.apk" \
  ./scripts/build-ai-gboard.sh
```

Repository tests:

```bash
python3 tests/test_static_contract.py
python3 tests/test_smali_patch_regressions.py
python3 tests/test_pinned_smali_patch_integration.py
python3 tests/test_build_guards.py
python3 tests/test_coexistence_resources.py
python3 -m py_compile scripts/*.py tests/*.py
git diff --check
```

Final APK verifier:

```bash
ZIPALIGN=/var/tmp/android-build-tools-35/android-15/zipalign \
  scripts/verify-built-apk.sh build/MyBoard-AI-17.8.5.apk
```

Always verify:

- Package/name/version/minSdk/targetSdk/ABI via `aapt dump badging`.
- Actual v3 signature and expected signer via `apksigner`.
- No `requiredSplitTypes`, `splitTypes`, or `isSplitRequired`.
- Fused resource entry parity and resource closure.
- All 15 stored ARM64 `.so` files have 16 KiB ZIP offsets and ELF `PT_LOAD` alignment at least `0x4000`.
- Exact DEX contracts for settings, model selection, prompts, debounce, and loading states.
- Clean install, update install from the previous signed version, official-Gboard coexistence, and installed `base.apk` byte identity.

## Runtime testing limitation

Available Redroid is x86_64. This APK contains only ARM64 libraries. Activity and IME entry paths fail before rendering with:

`EM_AARCH64 instead of EM_X86_64`

Therefore physical ARM64 Android 12L+ testing is required for:

- Settings model picker.
- AI polish entry and style UI.
- Custom translation/polish prompts.
- Translation loading state.
- Debounce timing and API-request count.
- Language chooser.
- Launcher and LatinIME startup.

Do not mark the existing partial test report passed until these are confirmed.

## Current tested candidate

- Local path: `build/MyBoard-AI-17.8.5.apk`
- Size: `82,289,137 bytes`
- SHA-256: `4fb9b745267416b16538b02f08f1126ebf452135fc4cb76727bf19171a3a3b24`
- Static/build/APK verification: passed
- Android 13 x86_64 installation and installed `base.apk` byte identity: passed
- ARM64 Android 12L+ toolbar/UI/safety acceptance: blocked pending a connected physical device

## Releases and prior artifacts

- v4 fused-resource candidate: `https://github.com/afasca/gboard-android/releases/tag/myboard-ai-v4`
- v5 language/settings candidate: `https://github.com/afasca/gboard-android/releases/tag/myboard-ai-v5`
- v5 direct APK: `https://github.com/afasca/gboard-android/releases/download/myboard-ai-v5/MyBoard-AI-v5.apk`
- PR: `https://github.com/afasca/gboard-android/pull/1`

A checkpoint GitHub release for the manual model picker is optional. If one is created, label it clearly as unverified on ARM64 and publish the exact SHA-256.

## Immediate next steps for the next engineer

1. Pull `vorflux/ai-translation-polish` and read this file plus `README.md`.
2. Re-run all repository tests and inspect the checkpoint commit.
3. Finish the four explicit user requirements: polish discoverability/styles, custom polish prompt, custom translation prompt, translation progress/debounce.
4. Regenerate authoritative smali for every Java change.
5. Build a naturally incremented update APK; do not use release labels as Android version names.
6. Run independent review and full static/build/install tests.
7. Update PR #1 description as a coherent full diff.
8. Publish a candidate and verify its public re-download hash.
9. Ask the user to validate all changed UI and request timing on a physical ARM64 phone, collecting logcat if anything fails.
