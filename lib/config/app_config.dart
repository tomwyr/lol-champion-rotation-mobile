import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig({
    required this.apiBaseUrl,
    required this.firebaseApiKey,
    required this.firebaseAppId,
    required this.firebaseMessagingSenderId,
    required this.firebaseProjectId,
    required this.firebaseStorageBucket,
    required this.firebaseIosBundleId,
  });

  final String apiBaseUrl;
  final String firebaseApiKey;
  final String firebaseAppId;
  final String firebaseMessagingSenderId;
  final String firebaseProjectId;
  final String firebaseStorageBucket;
  final String? firebaseIosBundleId;

  factory AppConfig.fromEnv() {
    return AppConfig(
      apiBaseUrl: dotenv.env['API_BASE_URL']!,
      firebaseApiKey: dotenv.env['FIREBASE_API_KEY']!,
      firebaseAppId: dotenv.env['FIREBASE_APP_ID']!,
      firebaseMessagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
      firebaseProjectId: dotenv.env['FIREBASE_PROJECT_ID']!,
      firebaseStorageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
      firebaseIosBundleId: dotenv.env['FIREBASE_IOS_BUNDLE_ID'],
    );
  }

  static Future<AppConfig> initEnv() async {
    await dotenv.load(fileName: '.env');
    return AppConfig.fromEnv();
  }
}
