import 'package:flutter/material.dart';

class AppMaterialTheme {
  static ThemeData light() => _themeFor(Brightness.light);

  static ThemeData dark() => _themeFor(Brightness.dark);

  static ThemeData _themeFor(Brightness brightness) {
    final theme = ThemeData.from(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: brightness,
      ),
    );
    return theme.copyWith(
      appBarTheme: _appBarTheme(theme),
      elevatedButtonTheme: _elevatedButtonTheme(),
    );
  }

  static const _seedColor = Color(0xff054463);

  static AppBarTheme _appBarTheme(ThemeData theme) {
    return AppBarTheme(
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: theme.colorScheme.surface,
      centerTitle: false,
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(192, 36),
      ),
    );
  }
}

class AppTheme {
  AppTheme.light()
      : textColor = Colors.black,
        descriptionColor = Colors.black54,
        iconColorDim = Colors.black38,
        selectedBackgroundColor = Colors.black12,
        availableColor = Colors.greenAccent[700]!,
        availableBackgroundColor = Colors.greenAccent[700]!.withValues(alpha: 0.05),
        predictionColor = Colors.amberAccent[700]!,
        predictionBackgroundColor = Colors.amberAccent[700]!.withValues(alpha: 0.05),
        unavailableColor = Colors.grey[500]!,
        notificationBackgroundColor = const Color(0xfff7f6f9),
        notificationBorderColor = const Color(0xffdcdbe0);

  AppTheme.dark()
      : textColor = Colors.white,
        descriptionColor = Colors.white70,
        iconColorDim = Colors.white54,
        selectedBackgroundColor = Colors.white10,
        availableColor = Colors.greenAccent[200]!,
        availableBackgroundColor = Colors.greenAccent[200]!.withValues(alpha: 0.1),
        predictionColor = Colors.amberAccent[100]!,
        predictionBackgroundColor = Colors.amberAccent[100]!.withValues(alpha: 0.1),
        unavailableColor = Colors.grey[700]!,
        notificationBackgroundColor = const Color(0xff181818),
        notificationBorderColor = const Color(0xff4e4e4e);

  final Color textColor;
  final Color descriptionColor;
  final Color iconColorDim;
  final Color selectedBackgroundColor;
  final Color availableColor;
  final Color availableBackgroundColor;
  final Color predictionColor;
  final Color predictionBackgroundColor;
  final Color unavailableColor;
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
