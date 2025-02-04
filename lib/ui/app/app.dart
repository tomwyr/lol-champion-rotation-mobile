import 'package:flutter/material.dart';

import '../notifications.dart';
import '../rotation/rotation_page.dart';
import '../theme.dart';
import 'app_initializer.dart';
import 'app_notifications.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AppInitializer(
      builder: (themeMode) => MaterialApp(
        themeMode: themeMode,
        theme: AppMaterialTheme.light(),
        darkTheme: AppMaterialTheme.dark(),
        builder: (context, child) => AppNotifications(
          child: NotificationsInitializer(
            child: child!,
          ),
        ),
        home: const RotationPage(),
      ),
    );
  }
}
