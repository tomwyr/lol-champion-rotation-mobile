import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_config.dart';
import '../core/events.dart';
import '../core/stores/app_store_store.dart';
import '../core/stores/observed_champions/observed_champions_store.dart';
import '../core/stores/champion_details/champion_details_store.dart';
import '../core/stores/local_settings_store.dart';
import '../core/stores/notifications/notifications_store.dart';
import '../core/stores/notifications_settings/notifications_settings_store.dart';
import '../core/stores/observed_rotations/observed_rotations_store.dart';
import '../core/stores/rotation/rotation_store.dart';
import '../core/stores/rotation_details/rotation_details_store.dart';
import '../core/stores/search_champions/search_champions_store.dart';
import '../data/api_client.dart';
import '../data/services/app_store_service.dart';
import '../data/services/auth_service.dart';
import '../data/services/fcm_service.dart';
import '../data/services/local_settings_service.dart';
import '../data/services/permissions_service.dart';

void setUpDependencies() {
  final appConfig = AppConfig.fromEnv();
  final sharedPrefs = SharedPreferencesAsync();
  final firebaseMessaging = FirebaseMessaging.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final authService = AuthService(firebaseAuth: firebaseAuth);
  final apiClient = AppApiClient(
    dio: Dio(BaseOptions(
      baseUrl: appConfig.apiBaseUrl,
    )),
    authService: authService,
  );
  final fcm = FcmService(
    messaging: firebaseMessaging,
    messages: FirebaseMessaging.onMessage,
  );
  final permissions = PermissionsService(messaging: firebaseMessaging);
  final localSettings = LocalSettingsService(sharedPrefs: sharedPrefs);
  final appEvents = AppEvents();
  final updateService = AppStoreService();

  GetIt.instance
    ..registerFactory(() => LocalSettingsStore(
          appEvents: appEvents,
          settings: localSettings,
        ))
    ..registerFactory(() => AppStoreStore(updateService: updateService))
    ..registerFactory(() => SearchChampionsStore(apiClient: apiClient))
    ..registerFactory(() => ObservedChampionsStore(
          appEvents: appEvents,
          apiClient: apiClient,
        ))
    ..registerFactory(() => ChampionDetailsStore(
          appEvents: appEvents,
          apiClient: apiClient,
        ))
    ..registerFactory(() => RotationStore(
          appEvents: appEvents,
          apiClient: apiClient,
          appSettings: localSettings,
        ))
    ..registerFactory(() => RotationDetailsStore(
          appEvents: appEvents,
          apiClient: apiClient,
        ))
    ..registerFactory(() => ObservedRotationsStore(
          appEvents: appEvents,
          apiClient: apiClient,
        ))
    ..registerFactory(() => NotificationsStore(
          apiClient: apiClient,
          fcm: fcm,
          permissions: permissions,
        ))
    ..registerFactory(() => NotificationsSettingsStore(
          apiClient: apiClient,
          permissions: permissions,
        ));
}
