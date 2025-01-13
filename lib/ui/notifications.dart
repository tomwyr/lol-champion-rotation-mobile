import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';

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
  @override
  void initState() {
    super.initState();
    locate<NotificationsStore>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void showError({required String message}) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      animationDuration: const Duration(milliseconds: 200),
      autoCloseDuration: const Duration(seconds: 3),
      closeOnClick: true,
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.none,
      description: Text(message),
    );
  }
}
