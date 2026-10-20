# ota_i18n_builder

A CLI code generator for the `ota_i18n` library. It generates strongly-typed Dart classes from your JSON translation files, enabling IDE autocomplete and compile-time safety for your internationalization strings.

## Features

- **Type-safe access**: `AppTexts.core.login_button` instead of `getText('core.login_button')`.
- **Placeholder support**: Automatically generates named parameters for strings containing `{{variable}}`.
- **Nested structure**: Reflects your JSON hierarchy in Dart classes.
- **Formatted output**: Uses `dart_style` for clean, readable code.

## Getting Started

1. Add `ota_i18n_builder` to your `dev_dependencies`.
2. Add `ota_i18n` to your `dependencies`.
3. Create your default translation file at `assets/i18n/default.json`.

## Usage

Run the generator using `dart run`:

```bash
dart run ota_i18n_builder --json=assets/i18n/default.json --out=lib/generated/app_texts.dart
```

### Options:
- `--json`: Path to your source JSON file (default: `assets/i18n/default.json`).
- `--out`: Path where the Dart file will be generated (default: `lib/gen/app_texts.dart`).
- `--class`: Name of the main helper class (default: `AppTexts`).
