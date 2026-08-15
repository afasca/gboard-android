# MyBoard AI roadmap and acceptance criteria

## Vision

MyBoard should feel like Gboard with a reliable, user-controlled OpenAI-compatible AI layer rather than a separate experimental app. AI behavior must be discoverable, private by default, controllable, economical with API calls, and reversible through Gboard's existing editing flows.

## Workstream A — AI translation

### Delivered

- OpenAI-compatible translation provider.
- Original language inventories and auto-detect source.
- Correct normalized/localized language picker maps.
- Secure endpoint/key configuration.
- Automatic model discovery.
- Manual model selection checkpoint.

### Remaining

- Editable translation system prompt with restore-default action.
- Obvious translation progress state.
- Configurable pause/debounce before request dispatch.
- Stale request/callback suppression and close-time cancellation.

### Acceptance criteria

- Language selector visibly lists languages.
- Starting translation immediately shows a loading state.
- During continuous typing, only the final input after the configured pause is sent.
- A stale earlier response never overwrites a newer request.
- Health probes never consume a charged translation request.
- Manual model selection is honored; automatic mode can be restored.
- Translation prompt edits persist and placeholders resolve correctly.

## Workstream B — AI polish

### Delivered

- Proofread interception and OpenAI request.
- Selected/full-text capture.
- Existing Gboard result, acceptance, replacement, selection restoration, and undo pipeline.
- Fixed top `AI 润色` access point with persisted microphone-slot migration; Jarvis is excluded from personalization and legacy customized orders while native voice remains customizable.
- Presets: standard, concise, formal, natural/conversational, professional.
- Custom style/prompt with restore-default behavior.

### Remaining

- Physical ARM64 Android 12L+ confirmation that fixed `AI 润色` and reserve native voice are discoverable on fresh and upgraded installs.
- Physical verification of all style, replacement, undo, visual, and protected-editor safety behavior.

### Acceptance criteria

- The fixed top slot shows AI polish without hidden feature flags or undocumented gestures, and native voice remains available exactly once in customization.
- Selected text is preferred; full captured text is used when no selection exists.
- Every preset produces a distinct system instruction while preserving meaning.
- Custom prompt persists privately and can be cleared.
- Loading/error/result acceptance remains native to the existing Writing Tools flow.

## Workstream C — configuration and security

### Delivered

- HTTPS-only Base URL validation.
- AES-256-GCM key encryption through Android Keystore.
- Endpoint-scoped automatic/manual model state.
- API key is not embedded or logged.

### Remaining

- Prompt fields, style, and debounce settings.
- Clear labeling of which configuration is endpoint-scoped and which is global.

### Acceptance criteria

- Invalid Base URLs cannot redirect a third-party key to the default service.
- API key never appears in logs, UI summaries, artifacts, or repository files.
- Switching endpoint restores that endpoint's model mode/choice.
- Manual missing-model errors never silently change user choice.

## Workstream D — packaging and coexistence

### Delivered

- Independent package `com.vorflux.gboard.inputmethod.latin`.
- Visible label MyBoard with original icon.
- Official Gboard coexistence.
- Full fused resources.
- minSdk 32.
- 16 KiB ARM64 ZIP and ELF alignment.
- Pinned signer verification.
- Natural app version increment: code 175894496, name `17.8.5.939743346-beta-arm64-v8a`.

### Acceptance criteria

- New candidates update-install over the previous MyBoard version with data retained.
- Official Gboard remains installed and selectable.
- No provider authority or custom-permission collisions.
- Public release download hash matches the locally tested bytes.

## Workstream E — testing

### Static/build gate

- Repository tests and `py_compile` pass.
- Build from pinned fused input and signer succeeds.
- APK verifier passes.
- Resource closure reports zero missing entries/configurations/files.
- Exact DEX inspection confirms requested code paths.

### ARM64 device gate

- Launcher opens.
- MyBoard can be enabled and selected as IME.
- Keyboard appears in an editable field.
- AI settings row and model picker work without duplicates.
- Language chooser displays.
- Translation progress and debounce are observable.
- AI translation works with automatic and manual models.
- AI polish entry, presets, custom prompt, replacement, and undo work.
- No resource, certificate, or native-loader crash in logcat.

## Definition of done

A release is complete only when the static/build gate and ARM64 device gate pass on the exact publicly downloadable APK, PR #1 describes the final behavior, and the single test report titled `Summary` is updated from partial to passed.
