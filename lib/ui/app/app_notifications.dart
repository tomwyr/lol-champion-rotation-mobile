import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../common/theme.dart';

class AppNotifications extends StatefulWidget {
  const AppNotifications({super.key, required this.child});

  final Widget child;

  static AppNotificationsState of(BuildContext context) {
    return context.findAncestorStateOfType<AppNotificationsState>()!;
  }

  @override
  State<AppNotifications> createState() => AppNotificationsState();
}

class AppNotificationsState extends State<AppNotifications> {
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(child: widget.child);
  }

  void showSuccess({required String message, AppNotificationDuration? duration}) {
    _showNotification(.success, message, duration);
  }

  void showInfo({required String message, AppNotificationDuration? duration}) {
    _showNotification(.info, message, duration);
  }

  void showWarning({required String message, AppNotificationDuration? duration}) {
    _showNotification(.warning, message, duration);
  }

  void showError({required String message, AppNotificationDuration? duration}) {
    _showNotification(.error, message, duration);
  }

  void _showNotification(
    ToastificationType type,
    String message, [
    AppNotificationDuration? duration,
  ]) {
    final appTheme = context.appTheme;
    duration ??= .standard;

    toastification.show(
      type: type,
      alignment: .bottomCenter,
      style: .flat,
      animationDuration: const Duration(milliseconds: 200),
      autoCloseDuration: Duration(milliseconds: duration.millis),
      closeOnClick: true,
      showProgressBar: false,
      closeButton: ToastCloseButton(showType: .none),
      backgroundColor: appTheme.notificationBackgroundColor,
      borderSide: BorderSide(color: appTheme.notificationBorderColor),
      boxShadow: [const BoxShadow(blurRadius: 8, spreadRadius: 1, color: Colors.black12)],
      foregroundColor: appTheme.textColor,
      description: Text(message),
    );
  }
}

enum AppNotificationDuration {
  short(millis: 2000),
  standard(millis: 4000);

  final int millis;

  const AppNotificationDuration({required this.millis});
}
