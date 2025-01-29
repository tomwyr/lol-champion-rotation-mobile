import 'package:flutter/material.dart';

class AppMaterialTheme {
  static ThemeData light() {
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

  static ThemeData dark() {
    return ThemeData.dark();
  }
}

class AppTheme {
  AppTheme.light() : descriptionColor = Colors.black54;

  AppTheme.dark() : descriptionColor = Colors.white70;

  final Color descriptionColor;
}

extension BuildContextAppTheme on BuildContext {
  AppTheme get appTheme {
    final brightness = Theme.of(this).brightness;
    return switch (brightness) {
      Brightness.dark => AppTheme.dark(),
      Brightness.light => AppTheme.light(),
    };
  }
}
