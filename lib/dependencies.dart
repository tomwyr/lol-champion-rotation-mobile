import 'package:app_set_id/app_set_id.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/app_config.dart';
import '../data/fcm_token.dart';
import 'core/stores/notifications.dart';
import 'core/stores/rotation.dart';
import 'core/stores/settings.dart';
import 'data/api_client.dart';

void setUpDependencies() {
  final apiClient = AppApiClient(
    baseUrl: AppConfig.fromEnv().apiBaseUrl,
  );
  final fcmToken = FcmTokenService(
    fcm: FirebaseMessaging.instance,
    appId: AppSetId(),
    sharedPrefs: SharedPreferencesAsync(),
  );

  GetIt.instance
    ..registerSingleton(RotationStore(apiClient: apiClient))
    ..registerSingleton(NotificationsStore(apiClient: apiClient, fcmToken: fcmToken))
    ..registerSingleton(SettingsStore(apiClient: apiClient, fcmToken: fcmToken));
}

T locate<T extends Object>() => GetIt.instance.get();
