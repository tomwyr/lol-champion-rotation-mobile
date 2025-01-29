import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../core/stores/app.dart';
import '../dependencies.dart';
import 'home.dart';
import 'notifications.dart';
import 'theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  AppStore get store => locate();

  @override
  Widget build(BuildContext context) {
    return AppNotifications(
      child: AppInitializer(
        child: NotificationsInitializer(
          child: ValueListenableBuilder(
            valueListenable: store.themeMode,
            builder: (context, value, _) => MaterialApp(
              themeMode: value,
              theme: AppMaterialTheme.light(),
              darkTheme: AppMaterialTheme.dark(),
              home: const HomePage(),
            ),
          ),
        ),
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  final store = locate<AppStore>();

  @override
  void initState() {
    super.initState();
    store.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: store.initialized,
      builder: (context, value, child) {
        return value ? widget.child : const SizedBox.shrink();
      },
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
