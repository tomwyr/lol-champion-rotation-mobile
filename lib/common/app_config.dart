import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig({required this.apiBaseUrl, required this.flavor});

  final String apiBaseUrl;
  final AppFlavor flavor;

  factory AppConfig.fromEnv() {
    return AppConfig(apiBaseUrl: dotenv.env['API_BASE_URL']!, flavor: .fromValue(appFlavor));
  }

  static Future<void> initEnv() async {
    await dotenv.load(fileName: '.env');
  }
}

enum AppFlavor {
  development,
  production;

  static AppFlavor fromValue(String? value) {
    for (var flavor in AppFlavor.values) {
      if (flavor.name == value) return flavor;
    }
    throw ArgumentError('Unexpected or missing flavor value: $value');
  }
}
