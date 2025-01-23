import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'home.dart';
import 'notifications.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AppNotifications(
      child: MaterialApp(
        theme: appTheme(),
        builder: (context, child) => NotificationsInitializer(
          child: child!,
        ),
        home: const HomePage(),
      ),
    );
  }

  ThemeData appTheme() {
    return ThemeData.light().copyWith(
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(192, 36),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

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
