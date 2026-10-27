import 'package:flutter/material.dart';
import 'package:ota_i18n_louis/ota_i18n_louis.dart';

// Giả sử file này được sinh ra từ lệnh:
// dart run ota_i18n_louis:ota_builder
class AppTexts {
  static late OtaI18n _ota;
  static void init(OtaI18n ota) => _ota = ota;

  static String get welcome => _ota.getText('common.welcome', 'Welcome!');
  static String greet({required String name}) => 
      _ota.getText('common.greet', 'Hello {{name}}').replaceAll('{{name}}', name);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo OTA i18n
  await OtaI18n.init(
    defaultJsonAssetPath: 'assets/i18n/default.json',
    apiUrl: 'https://api.example.com/en.json',
  );
  
  AppTexts.init(OtaI18n.instance);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('OTA i18n Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppTexts.welcome),
              Text(AppTexts.greet(name: 'Louis')),
            ],
          ),
        ),
      ),
    );
  }
}
