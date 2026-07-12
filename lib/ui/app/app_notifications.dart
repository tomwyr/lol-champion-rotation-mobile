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

  void showSuccess({
    required String message,
    AppNotificationDuration? duration,
    VoidCallback? onTap,
  }) {
    _showNotification(.success, message, duration, onTap);
  }

  void showInfo({required String message, AppNotificationDuration? duration, VoidCallback? onTap}) {
    _showNotification(.info, message, duration, onTap);
  }

  void showWarning({
    required String message,
    AppNotificationDuration? duration,
    VoidCallback? onTap,
  }) {
    _showNotification(.warning, message, duration, onTap);
  }

  void showError({
    required String message,
    AppNotificationDuration? duration,
    VoidCallback? onTap,
  }) {
    _showNotification(.error, message, duration, onTap);
  }

  void _showNotification(
    ToastificationType type,
    String message, [
    AppNotificationDuration? duration,
    VoidCallback? onTap,
  ]) {
    final appTheme = context.appTheme;
    final brightness = Theme.of(context).brightness;
    final shadowOpacity = switch (brightness) {
      .light => 0.12,
      .dark => 0.24,
    };
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
      boxShadow: [
        BoxShadow(
          blurRadius: 12,
          offset: const Offset(0, 4),
          color: Colors.black.withValues(alpha: shadowOpacity),
        ),
      ],
      foregroundColor: appTheme.textColor,
      description: Text(message),
      callbacks: ToastificationCallbacks(onTap: onTap != null ? (_) => onTap() : null),
    );
  }
}

enum AppNotificationDuration {
  short(millis: 2000),
  standard(millis: 4000);

  final int millis;

  const AppNotificationDuration({required this.millis});
}
