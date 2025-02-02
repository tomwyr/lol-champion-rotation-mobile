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
    return ThemeData.dark().copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(192, 36),
        ),
      ),
    );
  }
}

class AppTheme {
  AppTheme.light()
      : descriptionColor = Colors.black54,
        iconColorDim = Colors.black38,
        selectedBackgroundColor = Colors.black12,
        successColor = Colors.greenAccent[700]!,
        successBackgroundColor = Colors.greenAccent[700]!.withValues(alpha: 0.05);

  AppTheme.dark()
      : descriptionColor = Colors.white70,
        iconColorDim = Colors.white54,
        selectedBackgroundColor = Colors.white10,
        successColor = Colors.greenAccent[100]!,
        successBackgroundColor = Colors.greenAccent[100]!.withValues(alpha: 0.1);

  final Color descriptionColor;
  final Color iconColorDim;
  final Color selectedBackgroundColor;
  final Color successColor;
  final Color successBackgroundColor;
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
