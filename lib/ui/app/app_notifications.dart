import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppNotifications extends StatelessWidget {
  const AppNotifications({
    super.key,
    required this.child,
  });

  final Widget child;

  static AppNotifications of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<AppNotifications>()!;
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: child,
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
    toastification.show(
      type: type,
      style: ToastificationStyle.flat,
      animationDuration: const Duration(milliseconds: 200),
      autoCloseDuration: const Duration(seconds: 4),
      closeOnClick: true,
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.none,
      description: Text(message),
    );
  }
}
