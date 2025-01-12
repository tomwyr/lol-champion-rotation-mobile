import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig({
    required this.apiBaseUrl,
  });

  final String apiBaseUrl;

  factory AppConfig.fromEnv() {
    return AppConfig(
      apiBaseUrl: dotenv.env['API_BASE_URL']!,
    );
  }

  static Future<void> initEnv() async {
    await dotenv.load(fileName: '.env');
  }
}
