# MyBoard AI translation and polish handoff

Updated: 2026-08-14 15:15 UTC

## Repository and pull request

- Repository: `https://github.com/afasca/gboard-android`
- Branch: `vorflux/ai-translation-polish`
- Existing PR: `https://github.com/afasca/gboard-android/pull/1`
- Baseline checkpoint: `9f47c05 Checkpoint model picker and handoff`
- Do not open a second pull request; continue updating PR #1.

## Current delivery status

The implementation is feature-complete enough for a handoff checkpoint and a signed candidate APK has been built and fully verified by repository scripts.

- Candidate: `build/MyBoard-AI-17.8.5.apk`
- Size: `82,313,713 bytes`
- SHA-256: `a5def65657a2ee4f4115fadb6a3e3230affc8f9edbadef5c0c2a211c826ce0da`
- Package: `com.vorflux.gboard.inputmethod.latin`
- Label: `MyBoard`
- versionCode: `175894496`
- versionName: `17.8.5.939743346-beta-arm64-v8a`
- minSdk: 32
- targetSdk: 37
- ABI: ARM64 only (`arm64-v8a`)
- Signature: APK Signature Scheme v3; certificate SHA-256 `72f35793e9f17aba292fe6dd1607eca6b783cf779ca52b1561f03e5bc411ebeb`

Remaining effort is estimated at roughly 10–20%: consume final testing/review feedback, run feasible install verification, finalize the partial test report, commit/push, update PR #1, publish/download-check the APK, and obtain physical ARM64 Android 12L+ UI verification.

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
- removes the provider/module feature-flag gates;
- labels the access point `AI 润色`;
- sends the native Proofread event directly through `Lwtz.f(..., Lakhf.g, ...)`;
- preserves the native result, replace, and undo flow;
- normalizes all four toolbar order sources in `agsr.q/t/u/v` through one exact semicolon-token helper, injecting missing `jarvis` so server, experiment, persisted-upgrade, and fallback orders cannot hide the entry.

## Important implementation details

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
- `tests/test_build_guards.py`

## Tests already passed

```bash
export JAVA_HOME=/var/tmp/toolchain/jdk
export PATH=/var/tmp/toolchain/jdk/bin:/var/tmp/android-build-tools-35/android-15:$PATH
python3 tests/test_static_contract.py
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

The build passed apktool assembly, v3 signing, the full APK verifier, resource parity, resource closure, split-marker removal, ARM64-only ABI, 15 uncompressed libraries with 16 KiB ZIP alignment, and ELF `PT_LOAD >= 0x4000` checks.

## Pending tasks

1. Collect results from the reactivated testing task `test-plan-execute`.
2. Collect final review/simplify tasks `final-review` and `final-simplify`; address blocking findings only.
3. Rebuild and rerun static verification after any changes.
4. Perform feasible ADB installation/package extraction verification. This APK is ARM64 only; the local Redroid is x86_64 and cannot provide valid keyboard UI evidence. Do not claim UI success there.
5. Copy the APK to `/code/.generated_artifacts/apk/` for delivery.
6. Submit/update exactly one Test Report titled `Summary`, likely status `partial` until physical ARM64 testing.
7. Commit and push branch `vorflux/ai-translation-polish`.
8. Update existing PR #1 with a coherent current description and exact testing commands; do not create another PR.
9. Publish the candidate APK, download it again from the public GitHub URL, and compare SHA-256 and size.
10. Obtain real ARM64 Android 12L+ verification for MyBoard launch, keyboard enable/show, settings, model selection, translation debounce/progress, AI polish entry/styles, replace, and undo.

## Risks and review questions

- The earlier global `wtu.b(ZZ)=true` bypass was removed before handoff because it affected many unrelated Writing Tools call sites. The AI polish entry now relies on the targeted provider/module/state/click patches. Verify visibility on a physical device.
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

Copy the following prompt into the next session:

```text
Continue MyBoard AI translation/polish work in https://github.com/afasca/gboard-android on branch vorflux/ai-translation-polish and update existing PR #1 only. First run git checkout vorflux/ai-translation-polish, git pull, git status, and git log --oneline -10. Read docs/HANDOFF_AI_TRANSLATION_POLISH.md, docs/HANDOFF.md, docs/ROADMAP.md, and README.md before changing anything. The signed candidate build/MyBoard-AI-17.8.5.apk has SHA-256 a5def65657a2ee4f4115fadb6a3e3230affc8f9edbadef5c0c2a211c826ce0da and previously passed the full verifier. Continue from the Pending tasks section: collect/redo testing, review broad wtu.b(ZZ) bypass scope, verify the agsr persisted jarvis repair, rerun static/build verification after changes, perform feasible install verification, submit/update the single Test Report titled Summary as partial unless real ARM64 UI testing passes, commit/push, update PR #1, publish the APK, redownload it from GitHub and verify SHA-256/size. Do not commit build/gboard-ai.keystore. Do not claim UI success on x86_64 Redroid because the APK is ARM64 only. Clearly separate static/build verification, installation verification, and pending physical ARM64 testing.
```
