import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_config.dart';
import '../core/application/app_store_cubit.dart';
import '../core/application/champion_details/champion_details_cubit.dart';
import '../core/application/local_settings/local_settings_cubit.dart';
import '../core/application/notifications/notifications_cubit.dart';
import '../core/application/notifications_settings/notifications_settings_cubit.dart';
import '../core/application/observed_champions/observed_champions_cubit.dart';
import '../core/application/observed_rotations/observed_rotations_cubit.dart';
import '../core/application/rotation/rotation_cubit.dart';
import '../core/application/rotation_details/rotation_details_cubit.dart';
import '../core/application/search_champions/search_champions_cubit.dart';
import '../core/application/startup/startup_cubit.dart';
import '../core/events.dart';
import '../data/api_client.dart';
import '../data/services/app_store_service.dart';
import '../data/services/auth_service.dart';
import '../data/services/fcm_service.dart';
import '../data/services/local_settings_service.dart';
import '../data/services/permissions_service.dart';
import '../data/services/startup_service.dart';

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
  final localSettingsService = LocalSettingsService(sharedPrefs: sharedPrefs);
  final appEvents = AppEvents();
  final updateService = AppStoreService();
  final startupService = StartupService(sharedPrefs: sharedPrefs);

  GetIt.instance
    ..registerFactory(() => LocalSettingsCubit(
          appEvents: appEvents,
          service: localSettingsService,
        ))
    ..registerFactory(() => AppStoreCubit(updateService: updateService))
    ..registerFactory(() => StartupCubit(startupService: startupService, authService: authService))
    ..registerFactory(() => SearchChampionsCubit(apiClient: apiClient))
    ..registerFactory(() => ObservedChampionsCubit(
          appEvents: appEvents,
          apiClient: apiClient,
        ))
    ..registerFactory(() => ChampionDetailsCubit(
          appEvents: appEvents,
          apiClient: apiClient,
        ))
    ..registerFactory(() => RotationCubit(
          appEvents: appEvents,
          apiClient: apiClient,
          appSettings: localSettingsService,
        ))
    ..registerFactory(() => RotationDetailsCubit(
          appEvents: appEvents,
          apiClient: apiClient,
        ))
    ..registerFactory(() => ObservedRotationsCubit(
          appEvents: appEvents,
          apiClient: apiClient,
        ))
    ..registerFactory(() => NotificationsCubit(
          apiClient: apiClient,
          fcm: fcm,
          permissions: permissions,
        ))
    ..registerFactory(() => NotificationsSettingsCubit(
          apiClient: apiClient,
          permissions: permissions,
        ));
}
