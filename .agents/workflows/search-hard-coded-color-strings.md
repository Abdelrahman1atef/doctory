---
description: Search and fix hardcoded colors, assets, and user-facing strings to maintain design and localization consistency.
---

# Search and Resolve Hardcoded Colors, Assets, and Strings

## Goal

Locate and eliminate hardcoded UI styling (Hex/ARGB/Material colors), hardcoded asset path strings, and hardcoded user-facing text strings, substituting them with the project's centralized core foundations (`AppColors`, `AppAssets`, `easy_localization` / `LocaleKeys`).

---

## Mandatory Rules

1. **Design Tokens Only**: Never define raw hex colors (e.g. `Color(0xFF...)`) or raw Material palette colors (e.g. `Colors.orange`) directly in presentation widgets, views, or sections. Use `AppColors` fields.
2. **Unified Assets Class**: Never use hardcoded asset path strings (e.g. `'assets/images/logo.png'`) in the UI. All assets must be declared in `AppAssets` (`lib/core/utils/app_assets.dart`) and referenced programmatically (e.g., `AppAssets.images.logo`).
3. **Strict Localization**: Never hardcode user-facing strings in UI files. Every user-visible text must be fetched through `LocaleKeys.<key>.tr()`, with corresponding entries defined in `en.json` and `ar.json`.
4. **Backend/Logic Key Exemption**: Raw strings used as internal identifiers or backend API keys (e.g. `'male'`, `'auto_accept'`, `'min_rating'`) are allowed to remain as literal strings in logic and controller layers, but must never be rendered directly as raw text in the UI without localized mapping.

---

## Workflow Steps

### 1. Discovery & Search Phase

Use powerful regex patterns or tools to identify violations across the codebase:

#### A. Finding Hardcoded Colors
Search for any instantiation of color classes or standard material color palettes inside the `lib/features/` and `lib/shared/` directories:
* **Hex / Custom Colors**: 
  - Regex pattern: `Color\(0x[0-9A-Fa-f]{8}\)`
  - Direct Hex (e.g., `Color(0xFFF4F4F4)`): Replace with defined values in `AppColors` or create a new token.
* **Material Palette Colors**: 
  - Regex pattern: `\bColors\.[a-z]+`
  - Avoid raw Material colors like `Colors.amber` or `Colors.white`. Use the unified theme variables like `AppColors.warning` or `AppColors.white`.

#### B. Finding Hardcoded Assets
Search for raw asset string paths:
* **Image/SVG Paths**:
  - Regex pattern: `['"]assets/(images|icons|illustrations)/[^'"]+['"]`
  - Inline references like `'assets/icons/preferences.svg'` must be replaced by referencing the static properties inside `AppAssets.icons.<property>`.

#### C. Finding Hardcoded User-Facing Strings
Search for string literals wrapped directly inside `Text()` widgets or helper parameters:
* **Text Widgets**:
  - Regex pattern: `Text\(\s*['"][A-Za-z0-9\s]+['"]`
  - Example: `Text('Save Changes')` or `Text("From")`
* **Plain string parameters** that represent titles, descriptions, or hints:
  - Example: `description: 'Select your preferred age'`

---

### 2. Resolution & Refactoring Phase

For each discovered violation, refactor using the following systematic approach:

#### Step A. Standardize Colors
1. Check `lib/core/theme/app_colors.dart` to see if the target color already exists.
2. If it exists, replace the raw color instantiation with `AppColors.<colorName>`.
3. If it is a new design token required by design specs, declare it in `AppColors` first, then reference it.

#### Step B. Register Assets
1. Open `lib/core/utils/app_assets.dart` and locate the correct nested class (e.g., `_Icons`, `_Images`, `_Json`).
2. Add a new getter or constant containing the path.
3. Replace the inline hardcoded string in the feature with `AppAssets.<category>.<propertyName>`.

#### Step C. Localize Strings
1. Create a unique, descriptive key using snake_case (e.g., `save_changes`, `age_group_description`).
2. Add the key and its translations to:
   - `assets/translation/en.json` (English translation)
   - `assets/translation/ar.json` (Arabic translation)
3. Add the key as a static constant to `lib/core/app_strings/locale_keys.dart`:
   ```dart
   static const my_new_key = 'my_new_key';
   ```
4. Import `easy_localization` and `locale_keys.dart` in the target UI file.
5. Replace the hardcoded string with `LocaleKeys.my_new_key.tr()`.

---

### 3. Verification & Compliance Phase

Before marking the task as complete, perform these checks:

1. **Static Analysis**: Run `dart analyze` in the project root directory. Verify there are **zero** analyzer warnings or errors.
2. **Translation Completeness**: Switch the app language to both English and Arabic to verify that all newly localized strings fit the layout, render cleanly, and do not cause UI clipping.
3. **No Duplicate Keys**: Ensure that the newly added keys in `LocaleKeys` exactly match the keys in both JSON files to prevent runtime translation fallback issues.
