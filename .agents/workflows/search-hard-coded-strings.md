---
description: Workflow to identify and refactor hardcoded user-facing strings that have not been localized or added to AppStrings/LocaleKeys.
---

# Workflow: Search and Refactor Hardcoded User-Facing Strings

## Goal
Locate all hardcoded user-facing string literals in UI components that are NOT wrapped in localization calls (`.tr()`) and migrate them to the centralized localization system (`easy_localization`).

---

## 1. Discovery & Search Phase

Use the following regex search pattern to identify raw string literals used in UI properties (`Text`, `hintText`, `label`, etc.) that lack the `.tr()` method.

### Regex Search Pattern
`(Text|hintText|title|subtitle|label|text):\s*['"]([A-Za-z0-9\s!?,.-]+)['"](?!\.tr\(\))`

**Instructions for Android Studio:**
1. Open **Find in Files** (`Ctrl+Shift+F`).
2. Ensure **Regex** mode is checked (the `.*` icon).
3. Paste the pattern above.
4. Set the **Scope** to the specific feature directory (e.g., `lib/features/trips/`).

---

## 2. Resolution & Refactoring Phase

For each raw string identified by the search:

### Step A. Define the Key
1. Create a unique, descriptive snake_case key (e.g., `save_changes`, `no_trips_desc`).
2. Add the key and its value to `assets/translation/en.json` and `assets/translation/ar.json`.

### Step B. Update `LocaleKeys`
1. Add the new key to `lib/core/app_strings/locale_keys.dart`:
   ```dart
   static const my_new_key = 'my_new_key';
   ```

### Step C. Replace in Code
Replace the hardcoded string in the UI file with the localized reference:

*   **Before**:
    ```dart
    Text("Save Changes")
    ```
*   **After**:
    ```dart
    Text(LocaleKeys.save_changes.tr())
    ```

---

## 3. Verification & Compliance

1. **Verify Localization**: Switch app language between English and Arabic to ensure the text renders correctly.
2. **Static Analysis**: Run `dart analyze` to ensure no errors are introduced during refactoring.
3. **No Raw Strings**: Re-run the regex search to ensure the specific file/folder no longer contains raw user-facing string violations.
---
