import 'package:firebase_core/firebase_core.dart';

import 'app_config.dart';

class FirebaseConfig {
  static Future<void> initialize(AppConfig appConfig) async {
    final options = FirebaseOptions(
      apiKey: appConfig.firebaseApiKey,
      appId: appConfig.firebaseAppId,
      messagingSenderId: appConfig.firebaseMessagingSenderId,
      projectId: appConfig.firebaseProjectId,
      iosBundleId: appConfig.firebaseIosBundleId,
    );

    await Firebase.initializeApp(options: options);
  }
}
