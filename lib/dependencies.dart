import 'package:app_set_id/app_set_id.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/app_config.dart';
import 'core/stores/notifications.dart';
import 'core/stores/rotation.dart';
import 'core/stores/settings.dart';
import 'data/api_client.dart';
import 'data/fcm_service.dart';
import 'data/permissions_service.dart';

void setUpDependencies() {
  final sharedPrefs = SharedPreferencesAsync();
  final messaging = FirebaseMessaging.instance;
  final apiClient = AppApiClient(
    dio: Dio(BaseOptions(
      baseUrl: AppConfig.fromEnv().apiBaseUrl,
    )),
    appId: AppSetId(),
  );
  final fcm = FcmService(
    messaging: messaging,
    messages: FirebaseMessaging.onMessage,
  );
  final permissions = PermissionsService(
    sharedPrefs: sharedPrefs,
    messaging: messaging,
  );

  GetIt.instance
    ..registerSingleton(RotationStore(apiClient: apiClient))
    ..registerSingleton(NotificationsStore(
      apiClient: apiClient,
      fcm: fcm,
      permissions: permissions,
    ))
    ..registerSingleton(SettingsStore(
      apiClient: apiClient,
      permissions: permissions,
    ));
}

T locate<T extends Object>() => GetIt.instance.get();
