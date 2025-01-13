import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';

import '../core/model/notifications.dart';
import '../core/stores/notifications.dart';
import '../dependencies.dart';

class AppNotifications extends StatefulWidget {
  const AppNotifications({
    super.key,
    required this.child,
  });

  final Widget child;

  static AppNotificationsState of(BuildContext context) {
    return context.findAncestorStateOfType<AppNotificationsState>()!;
  }

  @override
  State<AppNotifications> createState() => AppNotificationsState();
}

class AppNotificationsState extends State<AppNotifications> {
  final store = locate<NotificationsStore>();

  late StreamSubscription notificationsSubscription;

  @override
  void initState() {
    super.initState();
    store.initialize();
    notificationsSubscription = store.notifications.listen(_onNotification);
  }

  @override
  void dispose() {
    notificationsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: widget.child,
    );
  }

  void showInfo({required String message}) {
    _showNotification(ToastificationType.info, message);
  }

  void showError({required String message}) {
    _showNotification(ToastificationType.error, message);
  }

  void _showNotification(ToastificationType type, String message) {
    toastification.show(
      type: type,
      style: ToastificationStyle.flat,
      animationDuration: const Duration(milliseconds: 200),
      autoCloseDuration: const Duration(seconds: 3),
      closeOnClick: true,
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.none,
      description: Text(message),
    );
  }

  void _onNotification(PushNotification notification) {
    switch (notification.type) {
      case PushNotificationType.rotationChanged:
        showInfo(message: 'New champion rotation is now available');
    }
  }
}
