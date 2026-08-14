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

The build requires:

- Android Build Tools 35 or newer because `zipalign` must support 16 KiB page alignment (`-P 16`).
- The existing repository development keystore whose certificate SHA-256 is pinned below. It is intentionally ignored by Git; set `KEYSTORE` to your secured copy. This signer cannot be regenerated because Gboard's internal certificate allowlist is bound to it.

The pinned `fused-gboard-安卓.apk` is used by default. A complete release build is:

```bash
KEYSTORE=/secure/path/gboard-ai.keystore \
ZIPALIGN=/path/to/android-sdk/build-tools/35.0.0/zipalign \
OUTPUT_APK="$PWD/build/MyBoard-AI-v4-minsdk32.apk" \
  ./scripts/build-ai-gboard.sh
```

To test another verified fused input, pass its path as the first argument and update the pinned input checks deliberately:

```bash
KEYSTORE=/secure/path/gboard-ai.keystore \
ZIPALIGN=/path/to/android-sdk/build-tools/35.0.0/zipalign \
OUTPUT_APK="$PWD/build/MyBoard-AI-v4-minsdk32.apk" \
  ./scripts/build-ai-gboard.sh /path/to/fused-gboard.apk
```

Output: `build/MyBoard-AI-v4-minsdk32.apk`

Use a fused/standalone APK as input. A Play base APK that declares `requiredSplitTypes="base__density"` does not contain the density drawables needed by Launcher and LatinIME; removing only that marker produces an installable APK that crashes with `Resources$NotFoundException`.

The build removes any Play-generated `requiredSplitTypes="base__density"` marker and restores `minSdkVersion` 32 from the original repository APK, while the fused input supplies the complete density resources. The patched certificate whitelist is bound to the repository development certificate SHA-256 `72f35793e9f17aba292fe6dd1607eca6b783cf779ca52b1561f03e5bc411ebeb`. Preserve `build/gboard-ai.keystore` between builds; using another key is intentionally rejected because it would fail Gboard's certificate-integrity check.

## Runtime limitations

The input contains only `arm64-v8a` libraries, so runtime validation requires an ARM64 Android device. It installs on x86_64 Redroid but cannot load its AArch64 native libraries there. The development certificate is explicitly added to Gboard's existing certificate whitelist (rather than disabling the check). Package/certificate-bound Google services may not recognize the independent clone, while AI translation and polish use the configured OpenAI-compatible service.
