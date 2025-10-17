import 'package:flutter/material.dart';

import '../common/theme.dart';
import '../notifications.dart';
import '../rotation_list/rotation_list_page.dart';
import 'app_cubits.dart';
import 'app_initializer.dart';
import 'app_notifications.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCubitsProvider(
      child: AppInitializer(
        builder: (themeMode) => MaterialApp(
          themeMode: themeMode,
          theme: AppMaterialTheme.light(),
          darkTheme: AppMaterialTheme.dark(),
          builder: (context, child) => AppNotifications(
            child: NotificationsInitializer(
              child: child!,
            ),
          ),
          home: RotationListPage.create(),
        ),
      ),
    );
  }
}
