# ota_i18n

A robust, type-safe, and framework-agnostic Over-The-Air (OTA) internationalization runtime engine for Flutter and Dart.

## Features

- **Type-safe**: Access translations via generated classes with IDE autocomplete (via `ota_i18n_builder`).
- **OTA Ready**: Built-in support for remote fetching and local caching.
- **Fast**: Flattened JSON structure for O(1) translation lookup.
- **Flexible**: Abstract interfaces for Network and Cache layers.

## Getting Started

1. Add `ota_i18n` to your `pubspec.yaml`.
2. Use `ota_i18n_builder` to generate your translation classes.

## Usage

```dart
import 'package:ota_i18n/ota_i18n.dart';

void main() async {
  await OtaI18n.init(
    defaultJsonAssetPath: 'assets/i18n/default.json',
    apiUrl: 'https://api.yoursite.com/translations/en.json',
  );
  
  print(OtaI18n.instance.getText('core.welcome', 'Welcome!'));
}
```

For type-safe usage, please refer to the `ota_i18n_builder` package.
