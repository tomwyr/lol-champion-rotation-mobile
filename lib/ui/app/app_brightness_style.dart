import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBrightnessStyle extends StatelessWidget {
  const AppBrightnessStyle({
    super.key,
    required this.themeMode,
    required this.child,
  });

  final ThemeMode themeMode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = switch (themeMode) {
      ThemeMode.system => MediaQuery.of(context).platformBrightness,
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
    };

    final (background, foreground) = switch (brightness) {
      Brightness.light => (Brightness.light, Brightness.dark),
      Brightness.dark => (Brightness.dark, Brightness.light),
    };

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarBrightness: background,
        statusBarIconBrightness: foreground,
      ),
      child: child,
    );
  }
}
