---
description: Search and replace hardcoded tr() keys with unified AppStrings class references to ensure code maintainability and consistent localization.
---

# Search and Resolve Hardcoded Translation Keys

## Goal

Locate all instances in features where translation keys are called as hardcoded string literals (e.g., `'next'.tr()` or `"please_select".tr()`), and replace them with programmatic references to the unified `AppStrings` class (e.g., `AppStrings.next.tr()`). If a key does not exist in `AppStrings`, register it properly.

---

## Mandatory Rules

1. **No Hardcoded Strings with `.tr()`**: All translations in the feature layers MUST reference `AppStrings` constants/getters. Never use raw `'key'.tr()` or `"key".tr()`.
2. **Naming Convention for `AppStrings`**: Getters in `AppStrings` must be defined using `camelCase` naming conventions, while the returned string value must match the snake_case keys used in ARB/JSON files.
   * Example: `static String get enterYourEmail => "enter_your_email";`
3. **No Duplicate Translation Getters**: Before adding a new getter to `AppStrings`, check if the translation key already has an existing getter defined in the class to avoid duplicate getters.

---

## Workflow Steps

### 1. Discovery & Search Phase

Use powerful regex patterns or tools to identify raw translation string violations across the `lib/features/` and `lib/shared/` directories:

#### A. Regex Pattern for Hardcoded `.tr()`
Search for single or double-quoted strings followed immediately by `.tr()`:
* **Regex Pattern**: `(['"])[a-zA-Z0-9_.-]+\1\.tr\(\)`
* **Examples matches**:
  - `'next'.tr()`
  - `"specify_gender_instruction".tr()`

---

### 2. Resolution & Refactoring Phase

For each raw key match found:

#### Step A. Check for Existing Getter in `AppStrings`
1. Open `lib/core/app_strings/app_strings.dart`.
2. Search for the raw translation key value (e.g., `"next"` or `"specify_gender_instruction"`).
3. If a getter exists (e.g., `static String get next => "next";`), note the getter's name.
4. Replace the raw string translation call in the feature file:
   - *Before*: `'next'.tr()`
   - *After*: `AppStrings.next.tr()`

#### Step B. Register New Key in `AppStrings`
If the raw translation key does not have a getter in `AppStrings`:
1. Convert the snake_case key to camelCase for the getter name.
   - Example: `"specify_gender_instruction"` becomes `specifyGenderInstruction`.
2. Add a new static getter inside `AppStrings` class in `lib/core/app_strings/app_strings.dart`:
   ```dart
   static String get specifyGenderInstruction => "specify_gender_instruction";
   ```
3. Import the `AppStrings` class in the target feature UI file:
   ```dart
   import '../../../../core/app_strings/app_strings.dart';
   ```
4. Replace the hardcoded string with the new getter call:
   - *Before*: `'specify_gender_instruction'.tr()`
   - *After*: `AppStrings.specifyGenderInstruction.tr()`

---

### 3. Verification & Compliance Phase

Before marking the task as complete, perform these checks:

1. **Static Analysis**: Run `dart analyze` in the project root directory. Verify there are **zero** analyzer warnings or errors.
2. **Translation Key Integrity**: Ensure that the returned value in the new getter matches exactly the translation key defined in the localization `.arb` or `.json` files.
3. **Correct Imports**: Ensure `AppStrings` is correctly imported and resolved in every refactored file.
