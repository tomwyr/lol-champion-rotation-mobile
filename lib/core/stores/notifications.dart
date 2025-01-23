import 'dart:async';

import '../../data/api_client.dart';
import '../../data/fcm_service.dart';
import '../../data/permissions_service.dart';
import '../model/notifications.dart';

class NotificationsStore {
  NotificationsStore({
    required this.apiClient,
    required this.fcm,
    required this.permissions,
  });

  final AppApiClient apiClient;
  final FcmService fcm;
  final PermissionsService permissions;

  Stream<PushNotification> get notifications => fcm.notifications;
  final StreamController<NotificationsEvent> events = StreamController.broadcast();

  void initialize() {
    _initToken();
    _initPermissions();
  }

  void _initToken() async {
    final user = await apiClient.user();
    if (!user.notificationsTokenSynced) {
      await fcm.getToken().then(_syncTokenData);
    }
    fcm.tokenChanged.listen(_syncTokenData);
  }

  void _initPermissions() async {
    if (!await permissions.requiresInitialCheck()) {
      return;
    }

    final settings = await apiClient.notificationsSettings();
    if (!settings.enabled) {
      await permissions.setInitialCheckDone();
      return;
    }

    final result = await permissions.requestNotificationsPermission();
    if (result == RequestPermissionResult.granted) {
      await permissions.setInitialCheckDone();
    } else {
      events.add(NotificationsEvent.permissionDesynced);
    }
  }

  Future<void> _syncTokenData(String token) async {
    await apiClient.updateNotificationsToken(NotificationsTokenInput(token: token));
  }
}

enum NotificationsEvent {
  permissionDesynced,
}
