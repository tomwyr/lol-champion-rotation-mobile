import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../../data/api_client.dart';
import '../../../data/services/fcm_service.dart';
import '../../../data/services/permissions_service.dart';
import '../../model/notifications.dart';
import '../../model/user.dart';
import 'notifications_state.dart';

part 'notifications_store.g.dart';

class NotificationsStore extends _NotificationsStore with _$NotificationsStore {
  NotificationsStore({
    required super.apiClient,
    required super.fcm,
    required super.permissions,
  });
}

abstract class _NotificationsStore with Store {
  _NotificationsStore({
    required this.apiClient,
    required this.fcm,
    required this.permissions,
  });

  final AppApiClient apiClient;
  final FcmService fcm;
  final PermissionsService permissions;

  Stream<PushNotification> get notifications => fcm.notifications;
  final StreamController<NotificationsEvent> events = StreamController.broadcast();

  @action
  Future<void> initialize() async {
    try {
      final user = await apiClient.user();
      await _initToken(user);
      await _initPermissions(user);
    } catch (_) {
      events.add(NotificationsEvent.initializationFailed);
    }
  }

  Future<void> _initToken(User user) async {
    if (user.notificationsStatus == UserNotificationsStatus.uninitialized) {
      await fcm.getToken().then(_syncTokenData);
    }
    fcm.tokenChanged.listen(_syncTokenData);
  }

  Future<void> _initPermissions(User user) async {
    if (user.notificationsStatus == UserNotificationsStatus.enabled) {
      final result = await permissions.requestNotificationsPermission();
      if (result != RequestPermissionResult.granted) {
        events.add(NotificationsEvent.permissionDesynced);
      }
    }
  }

  Future<void> _syncTokenData(String token) async {
    await apiClient.updateNotificationsToken(NotificationsTokenInput(token: token));
  }
}
