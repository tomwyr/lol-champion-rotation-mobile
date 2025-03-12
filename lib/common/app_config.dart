import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig({
    required this.apiBaseUrl,
    required this.authSecretKey,
  });

  final String apiBaseUrl;
  final String authSecretKey;

  factory AppConfig.fromEnv() {
    return AppConfig(
      apiBaseUrl: dotenv.env['API_BASE_URL']!,
      authSecretKey: dotenv.env['AUTH_SECRET_KEY']!,
    );
  }

  static Future<void> initEnv() async {
    await dotenv.load(fileName: '.env');
  }
}
