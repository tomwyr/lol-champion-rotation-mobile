import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../common/theme.dart';

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
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: widget.child,
    );
  }

  void showInfo({required String message}) {
    _showNotification(ToastificationType.info, message);
  }

  void showWarning({required String message}) {
    _showNotification(ToastificationType.warning, message);
  }

  void showError({required String message}) {
    _showNotification(ToastificationType.error, message);
  }

  void _showNotification(ToastificationType type, String message) {
    final appTheme = context.appTheme;

    toastification.show(
      type: type,
      style: ToastificationStyle.flat,
      animationDuration: const Duration(milliseconds: 200),
      autoCloseDuration: const Duration(seconds: 4),
      closeOnClick: true,
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.none,
      backgroundColor: appTheme.notificationBackgroundColor,
      borderSide: BorderSide(color: appTheme.notificationBorderColor),
      boxShadow: [
        const BoxShadow(
          blurRadius: 8,
          spreadRadius: 1,
          color: Colors.black12,
        ),
      ],
      foregroundColor: appTheme.textColor,
      description: Text(message),
    );
  }
}
