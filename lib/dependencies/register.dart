import 'package:app_set_id/app_set_id.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_config.dart';
import '../core/stores/app.dart';
import '../core/stores/champion_details.dart';
import '../core/stores/notifications.dart';
import '../core/stores/rotation.dart';
import '../core/stores/search_champions.dart';
import '../core/stores/settings.dart';
import '../data/api_client.dart';
import '../data/app_settings_service.dart';
import '../data/fcm_service.dart';
import '../data/permissions_service.dart';

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
  final permissions = PermissionsService(messaging: messaging);
  final appSettings = AppSettingsService(sharedPrefs: sharedPrefs);

  GetIt.instance
    ..registerFactory(() => AppStore(appSettings: appSettings))
    ..registerFactory(() => RotationStore(apiClient: apiClient))
    ..registerFactory(() => SearchChampionsStore(apiClient: apiClient))
    ..registerFactory(() => ChampionDetailsStore(apiClient: apiClient))
    ..registerFactory(() => NotificationsStore(
          apiClient: apiClient,
          fcm: fcm,
          permissions: permissions,
        ))
    ..registerFactory(() => SettingsStore(
          apiClient: apiClient,
          permissions: permissions,
        ));
}
