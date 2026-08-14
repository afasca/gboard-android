# Gboard AI translation and polish patch

This repository patches the supplied arm64 Gboard APK without rebuilding its raw Android 37 resources.

## Changes

- Replaces the built-in translation provider with an OpenAI-compatible AI translator.
- Reuses Gboard Writing Tools' existing **Proofread** toolbar flow as AI polish, including selected-text capture, loading/error UI, result confirmation, replacement, and undo.
- Adds an **OpenAI-compatible settings** row to Gboard's Translation settings.
- Fetches and filters models from `GET /v1/models`, then automatically selects a stable text-generation model.
- Encrypts the API key with a 256-bit Android Keystore AES-GCM key. It is never embedded in the APK or logged.
- Rejects invalid or non-HTTPS compatible-service URLs before saving, so a third-party key is never silently redirected to the OpenAI default.

The signed APK uses a development certificate and therefore cannot update the official Google-signed Gboard package in place. Uninstall the official package for the same user/profile before installing this build. The supplied APK is arm64-only, matching the repository input.

## Build

```bash
./scripts/build-ai-gboard.sh
```

Output: `build/gboard-ai-signed.apk`

The build removes the Play-generated `requiredSplitTypes="base__density"` marker because the repository contains only the base APK; the output can therefore be installed as one APK. The patched certificate whitelist is bound to the repository development certificate SHA-256 `72f35793e9f17aba292fe6dd1607eca6b783cf779ca52b1561f03e5bc411ebeb`. Preserve `build/gboard-ai.keystore` between builds; using another key is intentionally rejected because it would fail Gboard's certificate-integrity check.

## Runtime limitations

The input contains only `arm64-v8a` libraries, so runtime validation requires an ARM64 Android device. It installs on x86_64 Redroid but cannot load its AArch64 native libraries there. The development certificate is explicitly added to Gboard's existing three-entry certificate whitelist (rather than disabling the check), but the original Google signing key is unavailable and this APK still cannot update official Gboard in place.
