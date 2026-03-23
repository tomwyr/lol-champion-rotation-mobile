import 'dart:async';

import '../../../common/base_cubit.dart';
import '../../../data/api_client.dart';
import '../../../data/services/error_service.dart';
import '../../../data/services/fcm_service.dart';
import '../../../data/services/permissions_service.dart';
import '../../events.dart';
import '../../model/notifications.dart';
import '../../model/user.dart';
import 'notifications_state.dart';

class NotificationsCubit extends BaseCubit {
  NotificationsCubit({
    required this.apiClient,
    required this.fcm,
    required this.permissions,
    required this.appEvents,
    required this.errorService,
  }) : super(null);

  final AppApiClient apiClient;
  final FcmService fcm;
  final PermissionsService permissions;
  final AppEvents appEvents;
  final ErrorService errorService;

  var _launchNotificationEmitted = false;

  Stream<PushNotificationEvent> get notifications async* {
    await for (var event in fcm.notificationEvents) {
      if (event.context == .launch) {
        if (_launchNotificationEmitted) continue;
        _launchNotificationEmitted = true;
      }
      yield event;
    }
  }

  final StreamController<NotificationsEvent> events = .broadcast();

  Future<void> initialize() async {
    try {
      _forwardNotificationEvents();
      final user = await apiClient.user();
      await _initToken(user);
      await _initPermissions(user);
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
      events.add(.initializationFailed);
    }
  }

  void _forwardNotificationEvents() async {
    await for (var event in notifications) {
      if (event.context == .launch) continue;
      if (event.notification case RotationChangedNotification()) {
        appEvents.currentRotationChanged.notify();
      }
    }
  }

  Future<void> _initToken(User user) async {
    if (user.notificationsToken == null) {
      try {
        final token = await fcm.getToken();
        await _syncTokenData(token);
      } on FcmTokenError {
        // Fail silently and sync when tokenChanged fires.
      }
    }
    fcm.tokenChanged.listen(_syncTokenData);
  }

  Future<void> _initPermissions(User user) async {
    if (user.notificationsEnabled) {
      final result = await permissions.requestNotificationsPermission();
      if (result != .granted) {
        events.add(.permissionDesynced);
      }
    }
  }

  Future<void> _syncTokenData(String token) async {
    await apiClient.updateNotificationsToken(NotificationsTokenInput(token: token));
  }
}
