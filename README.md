# Gboard AI translation and polish patch

This repository patches the supplied arm64 Gboard APK without rebuilding its raw Android 37 resources.

## Changes

- Replaces the built-in translation provider with an OpenAI-compatible AI translator.
- Reuses Gboard Writing Tools' existing **Proofread** toolbar flow as AI polish, including selected-text capture, loading/error UI, result confirmation, replacement, and undo.
- Adds an **OpenAI-compatible settings** row to Gboard's Translation settings.
- Fetches and filters models from `GET /v1/models`, then automatically selects a stable text-generation model.
- Encrypts the API key with a 256-bit Android Keystore AES-GCM key. It is never embedded in the APK or logged.
- Rejects invalid or non-HTTPS compatible-service URLs before saving, so a third-party key is never silently redirected to the OpenAI default.
- Uses the visible name **MyBoard** while keeping the original icon, and preserves 16 KiB native-library alignment for modern ARM64 devices.

The build uses the independent package `com.vorflux.gboard.inputmethod.latin`, so it can be installed alongside the official Google-signed Gboard. It has separate settings, app data, and Android Keystore entries. The supplied APK is arm64-only, matching the repository input.

## Build

```bash
./scripts/build-ai-gboard.sh /path/to/fused-gboard.apk
```

Output: `build/gboard-ai-signed.apk`

Use a fused/standalone APK as input. A Play base APK that declares `requiredSplitTypes="base__density"` does not contain the density drawables needed by Launcher and LatinIME; removing only that marker produces an installable APK that crashes with `Resources$NotFoundException`.

The build removes the Play-generated `requiredSplitTypes="base__density"` marker because the repository contains only the base APK; the output can therefore be installed as one APK. The patched certificate whitelist is bound to the repository development certificate SHA-256 `72f35793e9f17aba292fe6dd1607eca6b783cf779ca52b1561f03e5bc411ebeb`. Preserve `build/gboard-ai.keystore` between builds; using another key is intentionally rejected because it would fail Gboard's certificate-integrity check.

## Runtime limitations

The input contains only `arm64-v8a` libraries, so runtime validation requires an ARM64 Android device. It installs on x86_64 Redroid but cannot load its AArch64 native libraries there. The development certificate is explicitly added to Gboard's existing certificate whitelist (rather than disabling the check). Package/certificate-bound Google services may not recognize the independent clone, while AI translation and polish use the configured OpenAI-compatible service.
