import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../core/model/notifications.dart';
import '../core/stores/notifications.dart';
import '../dependencies.dart';
import 'app/app_notifications.dart';

class NotificationsInitializer extends StatefulWidget {
  const NotificationsInitializer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<NotificationsInitializer> createState() => NotificationsInitializerState();
}

class NotificationsInitializerState extends State<NotificationsInitializer> {
  final store = locate<NotificationsStore>();

  late StreamSubscription notificationsSubscription;
  late StreamSubscription eventsSubscription;

  AppNotifications get notifications => AppNotifications.of(context);

  @override
  void initState() {
    super.initState();
    notificationsSubscription = store.notifications.listen(_onNotification);
    eventsSubscription = store.events.stream.listen(_onEvent);
    store.initialize();
  }

  @override
  void dispose() {
    eventsSubscription.cancel();
    notificationsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _onNotification(PushNotification notification) {
    switch (notification.type) {
      case PushNotificationType.rotationChanged:
        notifications.showInfo(message: 'New champion rotation is now available.');
    }
  }

  void _onEvent(NotificationsEvent event) {
    switch (event) {
      case NotificationsEvent.initializationFailed:
        notifications.showError(
          message: 'Failed to initialize notifications. Some features may not work properly.',
        );
      case NotificationsEvent.permissionDesynced:
        notifications.showWarning(
          message: 'Grant permission in the system settings to receive notifications.',
        );
    }
  }
}
