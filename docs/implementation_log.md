## Implementation Log

- Date: 2025-08-27
- Area: Localization & Sharing Text

Changes
- Added localized share text key with type placeholder
  - File: `lib/app/core/localization/tr.dart`
    - Key: `top_visual_share_text` (already existed)
    - Key: `unknown_gem` → "Bilinmeyen Taş"
  - File: `lib/app/core/localization/en.dart`
    - Key: `top_visual_share_text` → "GemAI Analysis Result: %{type}"
    - Key: `unknown_gem` → "Unknown Gem"

- Updated share invocation to use localization with parameter
  - File: `lib/app/modules/gem_result/widgets/top_visual_widget.dart`
    - Replaced hardcoded string with: `'top_visual_share_text'.trParams({'type': (result.type ?? 'unknown_gem'.tr)})`

Notes
- Ensures multi-language support for the share text.
- Provides a localized fallback when `result.type` is null.

