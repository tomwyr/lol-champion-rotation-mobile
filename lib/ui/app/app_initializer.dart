import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../core/stores/app_store_store.dart';
import '../../core/stores/local_settings_store.dart';
import '../../dependencies/locate.dart';
import 'app_brightness_style.dart';

class AppInitializer extends StatefulWidget {
  const AppInitializer({
    super.key,
    required this.builder,
  });

  final Widget Function(ThemeMode themeMode) builder;

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  final appStore = locate<AppStoreStore>();
  final localSettingsStore = locate<LocalSettingsStore>();

  @override
  void initState() {
    super.initState();
    appStore.checkForUpdate();
    localSettingsStore.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final initialized = localSettingsStore.initialized;
        final themeMode = localSettingsStore.themeMode;

        if (!initialized) {
          return const SizedBox.shrink();
        }
        return AppBrightnessStyle(
          themeMode: themeMode,
          child: widget.builder(themeMode),
        );
      },
    );
  }
}
