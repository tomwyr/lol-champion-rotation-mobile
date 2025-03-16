import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_config.dart';
import '../core/events.dart';
import '../core/stores/app.dart';
import '../core/stores/champion_details.dart';
import '../core/stores/notifications.dart';
import '../core/stores/rotation.dart';
import '../core/stores/rotation_bookmarks.dart';
import '../core/stores/rotation_details.dart';
import '../core/stores/search_champions.dart';
import '../core/stores/settings.dart';
import '../data/api_client.dart';
import '../data/app_settings_service.dart';
import '../data/auth_service.dart';
import '../data/fcm_service.dart';
import '../data/permissions_service.dart';
import '../data/update_service.dart';

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
  final appSettings = AppSettingsService(sharedPrefs: sharedPrefs);
  final appEvents = AppEvents();
  final updateService = UpdateService();

  GetIt.instance
    ..registerFactory(() => AppStore(
          appEvents: appEvents,
          appSettings: appSettings,
          updateService: updateService,
        ))
    ..registerFactory(() => RotationStore(
          appEvents: appEvents,
          apiClient: apiClient,
          appSettings: appSettings,
        ))
    ..registerFactory(() => SearchChampionsStore(apiClient: apiClient))
    ..registerFactory(() => ChampionDetailsStore(apiClient: apiClient))
    ..registerFactory(() => RotationDetailsStore(
          appEvents: appEvents,
          apiClient: apiClient,
        ))
    ..registerFactory(() => RotationBookmarksStore(
          appEvents: appEvents,
          apiClient: apiClient,
        ))
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
