import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionsService {
  PermissionsService({
    required this.sharedPrefs,
    required this.messaging,
  });

  final SharedPreferencesAsync sharedPrefs;
  final FirebaseMessaging messaging;

  static const _initialCheckKey = 'NOTIFICATIONS_PERMISSIONS_INITIAL_CHECK_DONE';

  /// Returns `true` for users who should potentially be prompted to grant the
  /// notifications permission, if they had enabled notifications before the
  /// logic requesting permissions was implemented.
  Future<bool> requiresInitialCheck() async {
    final didCheck = await sharedPrefs.getBool(_initialCheckKey) ?? false;
    if (didCheck) {
      return false;
    }

    final settings = await messaging.getNotificationSettings();
    return switch (settings.authorizationStatus) {
      AuthorizationStatus.notDetermined || AuthorizationStatus.denied => true,
      AuthorizationStatus.provisional || AuthorizationStatus.authorized => false,
    };
  }

  Future<void> setInitialCheckDone() async {
    await sharedPrefs.setBool(_initialCheckKey, true);
  }

  Future<RequestPermissionResult> requestNotificationsPermission() async {
    final settings = await messaging.requestPermission();
    return RequestPermissionResult.fromStatus(settings.authorizationStatus);
  }
}

enum RequestPermissionResult {
  granted,
  denied,
  unknown;

  factory RequestPermissionResult.fromStatus(AuthorizationStatus status) {
    return switch (status) {
      AuthorizationStatus.authorized ||
      AuthorizationStatus.provisional =>
        RequestPermissionResult.granted,
      AuthorizationStatus.denied => RequestPermissionResult.denied,
      AuthorizationStatus.notDetermined => RequestPermissionResult.unknown,
    };
  }
}
