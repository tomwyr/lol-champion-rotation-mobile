import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_config.dart';
import '../common/utils/changelog_parser.dart';
import '../core/application/app/app_cubit.dart';
import '../core/application/champion_details/champion_details_cubit.dart';
import '../core/application/feedback/feedback_cubit.dart';
import '../core/application/local_settings/local_settings_cubit.dart';
import '../core/application/notifications/notifications_cubit.dart';
import '../core/application/notifications_settings/notifications_settings_cubit.dart';
import '../core/application/observed_champions/observed_champions_cubit.dart';
import '../core/application/observed_rotations/observed_rotations_cubit.dart';
import '../core/application/rotation_details/rotation_details_cubit.dart';
import '../core/application/rotations/rotations_cubit.dart';
import '../core/application/search_champions/search_champions_cubit.dart';
import '../core/application/startup/startup_cubit.dart';
import '../core/events.dart';
import '../data/api_client.dart';
import '../data/cache/data_cache.dart';
import '../data/repositories/champion_detatils_repository.dart';
import '../data/repositories/rotation_details_repository.dart';
import '../data/repositories/rotations_repository.dart';
import '../data/services/app_service.dart';
import '../data/services/auth_service.dart';
import '../data/services/fcm_service.dart';
import '../data/services/local_settings_service.dart';
import '../data/services/permissions_service.dart';
import '../data/services/startup_service.dart';
import 'factories.dart';

void setUpDependencies() {
  final appConfig = AppConfig.fromEnv();
  final changelogParser = ChangelogParser();
  final sharedPrefs = SharedPreferencesAsync();
  final firebaseMessaging = FirebaseMessaging.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final authService = AuthService(firebaseAuth: firebaseAuth);
  final apiClient = AppApiClient(
    dio: Dio(BaseOptions(baseUrl: appConfig.apiBaseUrl)),
    authService: authService,
  );
  final dataCache = DataCache();
  final errorService = createErrorService();
  final fcm = FcmService(
    messaging: firebaseMessaging,
    onMessage: FirebaseMessaging.onMessage,
    onMessageOpenedApp: FirebaseMessaging.onMessageOpenedApp,
    errorService: errorService,
  );
  final permissions = PermissionsService(messaging: firebaseMessaging);
  final localSettingsService = LocalSettingsService(sharedPrefs: sharedPrefs);
  final appEvents = AppEvents();
  final updateService = AppService(
    errorService: errorService,
    appConfig: appConfig,
    changelogParser: changelogParser,
  );
  final startupService = StartupService(sharedPrefs: sharedPrefs);

  GetIt.instance
    ..registerSingleton(appEvents)
    ..registerSingleton(dataCache)
    ..registerFactory(() => LocalSettingsCubit(appEvents: appEvents, service: localSettingsService))
    ..registerFactory(() => AppCubit(errorService: errorService, appService: updateService))
    ..registerFactory(() => StartupCubit(startupService: startupService, authService: authService))
    ..registerFactory(() => SearchChampionsCubit(apiClient: apiClient, errorService: errorService))
    ..registerFactory(
      () => ObservedChampionsCubit(
        appEvents: appEvents,
        apiClient: apiClient,
        errorService: errorService,
      ),
    )
    ..registerFactory(
      () => ChampionDetailsCubit(
        appEvents: appEvents,
        repository: ChampionDetailsRepository(
          apiClient: apiClient,
          dataCache: dataCache,
          errorService: errorService,
        ),
      ),
    )
    ..registerFactory(
      () => RotationsCubit(
        appEvents: appEvents,
        repository: RotationsRepository(
          apiClient: apiClient,
          dataCache: dataCache,
          localSettingsService: localSettingsService,
          errorService: errorService,
        ),
      ),
    )
    ..registerFactory(
      () => RotationDetailsCubit(
        appEvents: appEvents,
        repository: RotationDetailsRepository(
          apiClient: apiClient,
          dataCache: dataCache,
          errorService: errorService,
        ),
      ),
    )
    ..registerFactory(
      () => ObservedRotationsCubit(
        appEvents: appEvents,
        apiClient: apiClient,
        errorService: errorService,
      ),
    )
    ..registerFactory(
      () => NotificationsCubit(
        apiClient: apiClient,
        fcm: fcm,
        permissions: permissions,
        appEvents: appEvents,
        errorService: errorService,
      ),
    )
    ..registerFactory(
      () => NotificationsSettingsCubit(
        apiClient: apiClient,
        permissions: permissions,
        errorService: errorService,
      ),
    )
    ..registerFactory(() => FeedbackCubit(apiClient: apiClient, errorService: errorService));
}
