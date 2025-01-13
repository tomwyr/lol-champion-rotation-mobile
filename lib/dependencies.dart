import 'package:app_set_id/app_set_id.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/fcm_token.dart';
import 'common/app_config.dart';
import 'core/stores/notifications.dart';
import 'core/stores/rotation.dart';
import 'core/stores/settings.dart';
import 'data/api_client.dart';
import 'data/fcm_notifications.dart';

void setUpDependencies() {
  final apiClient = AppApiClient(
    dio: Dio(BaseOptions(
      baseUrl: AppConfig.fromEnv().apiBaseUrl,
    )),
    appId: AppSetId(),
  );
  final fcmToken = FcmTokenService(
    fcm: FirebaseMessaging.instance,
    sharedPrefs: SharedPreferencesAsync(),
  );
  final fcmNotifications = FcmNotificationsService(
    messages: FirebaseMessaging.onMessage,
  );

  GetIt.instance
    ..registerSingleton(RotationStore(apiClient: apiClient))
    ..registerSingleton(NotificationsStore(
      apiClient: apiClient,
      fcmToken: fcmToken,
      fcmNotifications: fcmNotifications,
    ))
    ..registerSingleton(SettingsStore(apiClient: apiClient));
}

T locate<T extends Object>() => GetIt.instance.get();
