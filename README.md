# ota_i18n_louis

A robust, type-safe, and framework-agnostic Over-The-Air (OTA) internationalization solution for Flutter and Dart.

## 🚀 Installation

Add `ota_i18n_louis` to your `pubspec.yaml`:

```yaml
dependencies:
  ota_i18n_louis: ^1.0.0
```

## 🛠 Code Generation

Instead of using strings like `getText('home.title')`, you can generate type-safe classes.

1. Create your default JSON: `assets/i18n/default.json`.
2. Run the builder:
```bash
dart run ota_i18n_louis:ota_builder --json=assets/i18n/default.json --out=lib/generated/app_texts.dart
```

Now you can access translations with autocomplete: `AppTexts.home.title`.

## 📖 Usage

### Initialization

```dart
import 'package:ota_i18n_louis/ota_i18n_louis.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await OtaI18n.init(
    defaultJsonAssetPath: 'assets/i18n/default.json',
    apiUrl: 'https://your-api.com/en.json',
    // Optional: Inject your own fetcher or cache
    // fetcher: MyHttpFetcher(),
    // cache: MySecureCache(),
  );
  
  runApp(MyApp());
}
```

### Accessing Texts

- **Directly**: `OtaI18n.instance.getText('core.welcome', 'Welcome')`
- **Type-safe (Recommended)**: `AppTexts.core.welcome`
- **With Parameters**: `AppTexts.greeting(name: 'Louis')` // if JSON has "greeting": "Hello {{name}}"

## 🏗 System Architecture

This package provides:
1. **The Runtime Engine**: Handles JSON flattening for `O(1)` access and manages OTA updates.
2. **The CLI Builder**: A code generator that parses your JSON and creates a nested Dart class structure.
