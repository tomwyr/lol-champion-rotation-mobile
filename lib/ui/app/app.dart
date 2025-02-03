import 'package:flutter/material.dart';

import '../../core/stores/app.dart';
import '../../dependencies.dart';
import '../notifications.dart';
import '../rotation/rotation_page.dart';
import '../theme.dart';
import 'app_brightness_style.dart';
import 'app_notifications.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AppStore get store => locate();

  @override
  void initState() {
    super.initState();
    store.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return AppNotifications(
      child: ValueListenableBuilder(
        valueListenable: store.initialized,
        builder: (context, value, child) => value ? child! : const SizedBox.shrink(),
        child: NotificationsInitializer(
          child: ValueListenableBuilder(
            valueListenable: store.themeMode,
            builder: (context, value, _) => AppBrightnessStyle(
              themeMode: value,
              child: MaterialApp(
                themeMode: value,
                theme: AppMaterialTheme.light(),
                darkTheme: AppMaterialTheme.dark(),
                home: const RotationPage(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
