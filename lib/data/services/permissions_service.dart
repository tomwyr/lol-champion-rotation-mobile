import 'package:firebase_messaging/firebase_messaging.dart';

class PermissionsService {
  PermissionsService({required this.messaging});

  final FirebaseMessaging messaging;

  Future<RequestPermissionResult> requestNotificationsPermission() async {
    final settings = await messaging.requestPermission();
    return .fromStatus(settings.authorizationStatus);
  }
}

enum RequestPermissionResult {
  granted,
  denied,
  unknown;

  factory RequestPermissionResult.fromStatus(AuthorizationStatus status) {
    return switch (status) {
      .authorized || .provisional => .granted,
      .denied => .denied,
      .notDetermined => .unknown,
    };
  }
}
