import 'package:app_set_id/app_set_id.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../data/fcm_token.dart';
import 'core/notifications/store.dart';
import 'core/rotation/store.dart';
import 'data/api_client.dart';

RotationStore rotationStore() {
  return RotationStore(
    apiClient: AppApiClient(
      baseUrl: AppConfig.fromEnv().apiBaseUrl,
    ),
  );
}

NotificationsStore notificationsStore() {
  return NotificationsStore(
    apiClient: AppApiClient(
      baseUrl: AppConfig.fromEnv().apiBaseUrl,
    ),
    fcmToken: FcmTokenService(
      fcm: FirebaseMessaging.instance,
      appId: AppSetId(),
      sharedPrefs: SharedPreferencesAsync(),
    ),
  );
}
