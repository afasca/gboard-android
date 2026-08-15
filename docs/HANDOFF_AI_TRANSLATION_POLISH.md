# MyBoard AI translation and polish handoff

Updated: 2026-08-15 00:09 UTC

## Repository and pull request

- Repository: `https://github.com/afasca/gboard-android`
- Branch: `vorflux/ai-translation-polish`
- Existing PR: `https://github.com/afasca/gboard-android/pull/1`
- Baseline checkpoint: `9f47c05 Checkpoint model picker and handoff`
- Do not open a second pull request; continue updating PR #1.

## Current delivery status

The implementation is feature-complete enough for a handoff checkpoint. The current signed candidate below fixes both the model-picker content-panel conflict and the transitive module-registration gates that hid `AI 润色`, and has passed the full repository verifier.

- Candidate: `build/MyBoard-AI-17.8.5.apk`
- Size: `82,289,137 bytes`
- SHA-256: `4fb9b745267416b16538b02f08f1126ebf452135fc4cb76727bf19171a3a3b24`
- Status: AI polish entry registration publish candidate; do not rebuild after this checkpoint
- Package: `com.vorflux.gboard.inputmethod.latin`
- Label: `MyBoard`
- versionCode: `175894496`
- versionName: `17.8.5.939743346-beta-arm64-v8a`
- minSdk: 32
- targetSdk: 37
- ABI: ARM64 only (`arm64-v8a`)
- Signature: APK Signature Scheme v3; certificate SHA-256 `72f35793e9f17aba292fe6dd1607eca6b783cf779ca52b1561f03e5bc411ebeb`

Static/build verification and x86_64 Android 13 installation/package extraction verification are complete for these exact bytes. Remaining work is to commit/push, update PR #1 and the partial Summary test report, publish/download-check the exact candidate, and obtain physical ARM64 Android 12L+ UI verification.

## Product design

### Translation request lifecycle

Each provider owns one main-looper `Handler` and at most one pending `Runnable`.

1. Input begins a trailing-edge debounce timer.
2. New input removes the previous pending Runnable.
3. The delay comes from private settings: 300, 500, 800, 1200, or 2000 ms; default is 800 ms.
4. A generation counter is captured by the task and callback.
5. Dispatch and callback delivery are allowed only when generation still matches and the provider is not closed.
6. `c()` cancels pending work and invalidates in-flight callbacks; `close()` permanently closes and delegates to `c()`.
7. Health probes (`request.e == true`) return local `"hola"` without changing debounce/generation or cancelling real work.

The authoritative implementation is smali:

- `patch/smali/com/vorflux/gboardai/AiTranslateProvider.smali`
- `patch/smali/com/vorflux/gboardai/AiTranslateTask.smali`
- `patch/smali/com/vorflux/gboardai/AiTranslateCallback.smali`

A readable behavioral reference is intentionally excluded from the javac source list:

- `patch/src/com/vorflux/gboardai/AiTranslateProvider.java`

### Translation state UI

The patch uses Gboard's native `TranslateKeyboard.a(int)` state machine rather than sending fake `Lacif(String)` results.

- State 1 starts the native spinner before provider dispatch.
- State 2 clears it on terminal callback, input cancellation, and stop.
- Accessibility status uses existing resource `0x7f140d8c` (`Translating...`).
- API/transport/empty-result failures are mapped to `Lacif(1)`, not state 4; decoded `acih.a()` treats state 1 as failure/disabled rather than normal completion.

Known UX limitation: debounce and network dispatch currently share the same native spinner. There is no separate visible text transition from “等待输入停顿…” to “正在翻译…”.

### Translation prompt configuration

Private SharedPreferences file: `gboard_ai_private`, mode `Context.MODE_PRIVATE`.

Default prompt:

```text
Translate the text from {source} to {target}. Preserve meaning, tone, formatting, line breaks, emoji, names, URLs, numbers, and placeholders. Do not add explanations or invent facts. Return only the translated text.
```

`{source}` and `{target}` are replaced literally at request time. API keys remain encrypted with Android Keystore AES-256-GCM. No source text, translated text, prompt, or key logging was added.

### AI polish design

Settings expose six modes:

- standard
- concise
- formal
- natural
- professional
- custom

Preset modes extend `AiConfig.DEFAULT_POLISH_PROMPT`; only custom reads the saved custom prompt. The active Proofread path calls `AiWritingTools.polish()`, which builds the selected-style prompt and calls `OpenAiClient.complete()`.

The `AI 润色` access point:

- is inserted in the default toolbar order before search;
- removes the direct `wqp` registration gate and the transitive `wgw` gate so the existing `Lwgv.a` minors-readiness producer can initialize;
- preserves `wqp`'s `Lwgv.a` dependency and the native `Lwtu.J`/`Lahce.b` minors checks rather than forcing readiness;
- removes the remaining provider/module feature-flag gates while retaining native editor/context eligibility;
- labels the access point `AI 润色`;
- sends the native Proofread event directly through `Lwtz.f(..., Lakhf.g, ...)`;
- preserves the native result, replace, and undo flow;
- normalizes all four toolbar order sources in `agsr.q/t/u/v` through one exact semicolon-token helper, injecting missing `jarvis` so server, experiment, persisted-upgrade, and fallback orders cannot hide the entry.

## Important implementation details

### Model picker list visibility

Android `AlertDialog` uses one content panel for either a message or a list. Calling both `setMessage()` and `setSingleChoiceItems()` fetched models successfully but hid every model row, matching the user screenshot. The picker now omits `setMessage()`, keeps stale-manual-model context in the title, and has Java/smali regression assertions.

### Java to smali synchronization

Generated Java classes were compiled with Java 8 bytecode using Java 17, D8 min API 32, and apktool's shaded baksmali 3.0.9. The generated smali lives in `patch/smali/com/vorflux/gboardai/`.

Java sources included:

- `AiConfig.java`
- `AiSettingsDialog.java`
- `AiWritingTools.java`
- `OpenAiClient.java`

The following are manually maintained smali or manually backed behavior and must not be overwritten blindly:

- `AiPolishFuture.smali`
- `AiPolishListener.smali`
- `AiSettingsClick.smali`
- `AiTranslateCallback.smali`
- `AiTranslateProvider.smali`
- `AiTranslateTask.smali`

`AiSettingsDialog.java` now desugars to eight `AiSettingsDialog$$ExternalSyntheticLambda0..7.smali` files. The prior anonymous `AiSettingsDialog$1...$2` files are deleted.

### Patch composition

`patch_translation_provider()` and `patch_translation_progress()` both transform `smali/aciv.smali`. The main patcher must first produce the provider-patched in-memory text and then feed that text into the progress patch. Independent reads/writes lose one patch.

### Signing and Build Tools 35

The input fused APK has signer rotation. Build Tools 35 prints generic signer lines such as:

```text
Signer (minSdkVersion=24, maxSdkVersion=32) certificate SHA-256 digest: f0fd6c...
```

Therefore scripts now search all `certificate SHA-256 digest:` lines for the exact expected digest and do not rely on `Signer #1`.

The ignored signing keystore is:

- `build/gboard-ai.keystore`
- alias: `gboard-ai`
- password: `android`
- do not commit it

## Files changed

Primary source/patch files:

- `patch/src/com/vorflux/gboardai/AiConfig.java`
- `patch/src/com/vorflux/gboardai/AiSettingsDialog.java`
- `patch/src/com/vorflux/gboardai/AiWritingTools.java`
- `patch/src/com/vorflux/gboardai/OpenAiClient.java`
- `patch/src/com/vorflux/gboardai/AiTranslateProvider.java`
- corresponding generated smali
- manual provider/task/callback smali
- `scripts/apply-smali-patches.py`
- `scripts/build-ai-gboard.sh`
- `scripts/remove-required-split.py`
- `scripts/verify-built-apk.sh`
- `tests/test_static_contract.py`
- `tests/test_smali_patch_regressions.py`
- `tests/test_pinned_smali_patch_integration.py`
- `tests/test_build_guards.py`

## Tests already passed

```bash
export JAVA_HOME=/var/tmp/toolchain/jdk
export PATH=/var/tmp/toolchain/jdk/bin:/var/tmp/android-build-tools-35/android-15:$PATH
python3 tests/test_static_contract.py
python3 tests/test_smali_patch_regressions.py
python3 tests/test_pinned_smali_patch_integration.py
python3 tests/test_build_guards.py
python3 tests/test_coexistence_resources.py
python3 -m py_compile scripts/*.py tests/*.py
git diff --check
```

All passed.

Candidate build command:

```bash
export JAVA_HOME=/var/tmp/toolchain/jdk
export PATH=/var/tmp/toolchain/jdk/bin:/var/tmp/android-build-tools-35/android-15:$PATH
KEYSTORE="$PWD/build/gboard-ai.keystore" \
ZIPALIGN=/var/tmp/android-build-tools-35/android-15/zipalign \
OUTPUT_APK="$PWD/build/MyBoard-AI-17.8.5.apk" \
  ./scripts/build-ai-gboard.sh
```

The build passed apktool assembly, v3 signing, the full APK verifier, resource parity, resource closure, split-marker removal, ARM64-only ABI, 15 uncompressed libraries with 16 KiB ZIP alignment, and ELF `PT_LOAD >= 0x4000` checks. Decoding the exact candidate confirmed both registration gates are absent while the `Lwgv.a` minors dependency/producer and native editor/context guards remain. Android 13 x86_64 installation succeeded, and its pulled installed `base.apk` matched the candidate by size, SHA-256, and `cmp`; this is package evidence only, not ARM64 UI evidence.

## Pending tasks

1. Update existing PR #1 with a coherent current description and exact testing commands; do not create another PR.
2. Submit/update exactly one Test Report titled `Summary` with partial status until physical ARM64 testing.
3. Publish the exact candidate APK, download it again from the public GitHub URL, and compare SHA-256 and size.
4. Obtain real ARM64 Android 12L+ verification for MyBoard launch, keyboard enable/show, settings, model selection, translation debounce/progress, AI polish entry/styles, replace, and undo.

## Risks and review questions

- The earlier global `wtu.b(ZZ)=true` bypass and broad `wok.k()` replacement were removed because they affected unrelated Writing Tools call sites or bypassed native safety checks. Only the required `wqp`/`wgw` registration gates and the `wsc` polish-provider gate are bypassed. `wqp` still waits for the existing minors-readiness tag, and `wsc` still passes native editor/context eligibility before its targeted gate bypass. Verify visibility and password/incognito/unsupported-editor behavior on a physical device.
- The native spinner is visible, but separate debounce-versus-network text is not implemented.
- `gc()` does not have an independently patched spinner clear; teardown currently relies on `close()`/other UI stop paths. Verify on device.
- Static source-string tests are not runtime timing tests. Physical-device tests must confirm burst coalescing and stale-response rejection against a deterministic API endpoint.

## Physical ARM64 acceptance checklist

- MyBoard installs/upgrades over 17.8.4 with the same signing key.
- Official Gboard and MyBoard coexist.
- Launcher and LatinIME start.
- AI settings are reachable, scroll correctly, save/reset correctly, and survive process restart.
- All debounce presets coalesce rapid bursts into one final-text request.
- Old/slow responses never overwrite newer input.
- Input cancellation and close remove spinner and prevent stale updates.
- Health probe neither sends paid traffic nor cancels a real request.
- Translation prompt placeholders and formatting behave correctly.
- `AI 润色` appears for fresh and upgrade installs.
- Six styles send expected prompts.
- Native result, replace, error, and undo flows work.

## Handoff prompt

When handing off again, point the next engineer to the current Pending tasks and require them to treat the published release asset hash/size as authoritative. Do not rebuild or substitute different APK bytes without updating the candidate metadata and rerunning all gates.
