import 'package:flutter/material.dart';

import '../../core/stores/local_settings.dart';
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
  final store = locate<LocalSettingsStore>();

  @override
  void initState() {
    super.initState();
    store.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: store.initialized,
      builder: (context, value, child) => value ? child! : const SizedBox.shrink(),
      child: ValueListenableBuilder(
        valueListenable: store.themeMode,
        builder: (context, value, _) => AppBrightnessStyle(
          themeMode: value,
          child: widget.builder(value),
        ),
      ),
    );
  }
}
