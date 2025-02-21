import 'package:flutter/material.dart';

class AppMaterialTheme {
  static ThemeData light() {
    return ThemeData.light().copyWith(
      appBarTheme: _appBarTheme,
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: _buttonMinSize,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData.dark().copyWith(
      appBarTheme: _appBarTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: _buttonMinSize,
        ),
      ),
    );
  }

  static const _buttonMinSize = Size(192, 36);

  static const _appBarTheme = AppBarTheme(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
  );
}

class AppTheme {
  AppTheme.light()
      : textColor = Colors.black,
        descriptionColor = Colors.black54,
        iconColorDim = Colors.black38,
        selectedBackgroundColor = Colors.black12,
        successColor = Colors.greenAccent[700]!,
        successBackgroundColor = Colors.greenAccent[700]!.withValues(alpha: 0.05),
        notificationBackgroundColor = const Color(0xfff7f6f9),
        notificationBorderColor = const Color(0xffdcdbe0);

  AppTheme.dark()
      : textColor = Colors.white,
        descriptionColor = Colors.white70,
        iconColorDim = Colors.white54,
        selectedBackgroundColor = Colors.white10,
        successColor = Colors.greenAccent[100]!,
        successBackgroundColor = Colors.greenAccent[100]!.withValues(alpha: 0.1),
        notificationBackgroundColor = const Color(0xff181818),
        notificationBorderColor = const Color(0xff4e4e4e);

  final Color textColor;
  final Color descriptionColor;
  final Color iconColorDim;
  final Color selectedBackgroundColor;
  final Color successColor;
  final Color successBackgroundColor;
  final Color notificationBackgroundColor;
  final Color notificationBorderColor;
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
