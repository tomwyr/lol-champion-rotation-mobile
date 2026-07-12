import 'package:flutter/material.dart';

abstract final class AppColors {
  static const navy950 = Color(0xff030713);
  static const navy900 = Color(0xff07122f);
  static const darkBackground = Color(0xff050b1d);
  static const navy800 = Color(0xff0a1a46);
  static const navy700 = Color(0xff10275f);
  static const surfaceRaised = Color(0xff101a2f);
  static const text = Color(0xfff7f9ff);
  static const textMuted = Color(0xffb8c5dc);
  static const green = Color(0xff62e6a6);
  static const amber = Color(0xffffd166);
  static const blue = Color(0xff81a9ff);

  static const lightBackground = Color(0xfff5f7fc);
  static const lightSurfaceRaised = Color(0xffe9eef8);
  static const lightText = Color(0xff0b1120);
  static const lightTextMuted = Color(0xff475569);
  static const lightPrimary = Color(0xff173d91);
  static const lightGreen = Color(0xff087a4a);
  static const lightAmber = Color(0xff8a5700);
}

class AppMaterialTheme {
  static ThemeData light() => _themeFor(.light);

  static ThemeData dark() => _themeFor(.dark);

  static ThemeData _themeFor(Brightness brightness) {
    final colorScheme = switch (brightness) {
      .light => _lightColorScheme,
      .dark => _darkColorScheme,
    };
    final theme = ThemeData.from(useMaterial3: true, colorScheme: colorScheme);
    final textTheme = _textTheme(theme.textTheme);

    return theme.copyWith(
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      primaryTextTheme: _textTheme(theme.primaryTextTheme),
      hintColor: colorScheme.onSurfaceVariant,
      appBarTheme: _appBarTheme(theme, textTheme),
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme),
      filledButtonTheme: _filledButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      switchTheme: _switchTheme(colorScheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
    );
  }

  static AppBarTheme _appBarTheme(ThemeData theme, TextTheme textTheme) {
    return AppBarTheme(
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: theme.colorScheme.surface,
      centerTitle: false,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: theme.colorScheme.onSurface,
        fontSize: 20,
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: _buttonShape,
      ),
    );
  }

  static FilledButtonThemeData _filledButtonTheme() {
    return FilledButtonThemeData(style: FilledButton.styleFrom(shape: _buttonShape));
  }

  static OutlinedButtonThemeData _outlinedButtonTheme() {
    return OutlinedButtonThemeData(style: OutlinedButton.styleFrom(shape: _buttonShape));
  }

  static TextButtonThemeData _textButtonTheme() {
    return TextButtonThemeData(style: TextButton.styleFrom(shape: _buttonShape));
  }

  static final _buttonShape = RoundedRectangleBorder(borderRadius: .circular(12));

  static SwitchThemeData _switchTheme(ColorScheme colorScheme) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }
        if (states.contains(WidgetState.selected)) return colorScheme.onPrimary;
        return colorScheme.onSurfaceVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.selected)) return colorScheme.primary;
        return colorScheme.onSurfaceVariant.withValues(alpha: 0.24);
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.transparent;
        return colorScheme.onSurfaceVariant.withValues(
          alpha: states.contains(WidgetState.disabled) ? 0.2 : 0.5,
        );
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        final color = states.contains(WidgetState.selected)
            ? colorScheme.primary
            : colorScheme.onSurface;
        return color.withValues(alpha: 0.1);
      }),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
    );
  }

  static TextTheme _textTheme(TextTheme theme) {
    TextStyle? inter(TextStyle? style) => style?.copyWith(fontFamily: 'Inter');
    TextStyle? chakraPetch(TextStyle? style) => style?.copyWith(fontFamily: 'Chakra Petch');

    return theme.copyWith(
      displayLarge: chakraPetch(theme.displayLarge),
      displayMedium: chakraPetch(theme.displayMedium),
      displaySmall: chakraPetch(theme.displaySmall),
      headlineLarge: chakraPetch(theme.headlineLarge),
      headlineMedium: chakraPetch(theme.headlineMedium)?.copyWith(fontSize: 24),
      headlineSmall: chakraPetch(theme.headlineSmall)?.copyWith(fontSize: 20),
      titleLarge: chakraPetch(theme.titleLarge),
      titleMedium: chakraPetch(theme.titleMedium),
      titleSmall: chakraPetch(theme.titleSmall),
      labelLarge: chakraPetch(theme.labelLarge),
      labelMedium: chakraPetch(theme.labelMedium),
      labelSmall: chakraPetch(theme.labelSmall),
      bodyLarge: inter(theme.bodyLarge),
      bodyMedium: inter(theme.bodyMedium),
      bodySmall: inter(theme.bodySmall),
    );
  }

  static const _darkColorScheme = ColorScheme(
    brightness: .dark,
    primary: AppColors.blue,
    onPrimary: AppColors.navy950,
    primaryContainer: AppColors.navy700,
    onPrimaryContainer: AppColors.text,
    secondary: AppColors.green,
    onSecondary: AppColors.navy950,
    secondaryContainer: AppColors.navy800,
    onSecondaryContainer: AppColors.text,
    tertiary: AppColors.amber,
    onTertiary: AppColors.navy950,
    tertiaryContainer: AppColors.navy800,
    onTertiaryContainer: AppColors.text,
    error: Color(0xffffb4ab),
    onError: Color(0xff690005),
    errorContainer: Color(0xff93000a),
    onErrorContainer: Color(0xffffdad6),
    surface: AppColors.darkBackground,
    onSurface: AppColors.text,
    onSurfaceVariant: AppColors.textMuted,
    outline: Color(0xff53627d),
    outlineVariant: Color(0xff293650),
    inverseSurface: AppColors.text,
    onInverseSurface: AppColors.navy950,
    inversePrimary: AppColors.lightPrimary,
    surfaceContainerLowest: AppColors.darkBackground,
    surfaceContainerLow: AppColors.darkBackground,
    surfaceContainer: AppColors.darkBackground,
    surfaceContainerHigh: AppColors.darkBackground,
    surfaceContainerHighest: AppColors.darkBackground,
  );

  static const _lightColorScheme = ColorScheme(
    brightness: .light,
    primary: AppColors.lightPrimary,
    onPrimary: Colors.white,
    primaryContainer: Color(0xffdbe6ff),
    onPrimaryContainer: AppColors.navy900,
    secondary: AppColors.lightGreen,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xffbdf4d6),
    onSecondaryContainer: Color(0xff063d29),
    tertiary: AppColors.lightAmber,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xffffe3a6),
    onTertiaryContainer: Color(0xff493000),
    error: Color(0xffba1a1a),
    onError: Colors.white,
    errorContainer: Color(0xffffdad6),
    onErrorContainer: Color(0xff410002),
    surface: AppColors.lightBackground,
    onSurface: AppColors.lightText,
    onSurfaceVariant: AppColors.lightTextMuted,
    outline: Color(0xff64748b),
    outlineVariant: Color(0xffcbd5e1),
    inverseSurface: AppColors.navy900,
    onInverseSurface: AppColors.text,
    inversePrimary: AppColors.blue,
    surfaceContainerLowest: AppColors.lightBackground,
    surfaceContainerLow: AppColors.lightBackground,
    surfaceContainer: AppColors.lightBackground,
    surfaceContainerHigh: AppColors.lightBackground,
    surfaceContainerHighest: AppColors.lightBackground,
  );
}

class AppTheme {
  AppTheme.light()
    : textColor = AppColors.lightText,
      textColorDim = AppColors.lightTextMuted,
      descriptionColor = AppColors.lightTextMuted,
      iconColorDim = AppColors.lightTextMuted.withValues(alpha: 0.72),
      selectedBackgroundColor = AppColors.lightPrimary.withValues(alpha: 0.1),
      availableColor = AppColors.lightGreen,
      availableBackgroundColor = AppColors.green.withValues(alpha: 0.14),
      predictionColor = AppColors.lightAmber,
      predictionBackgroundColor = AppColors.amber.withValues(alpha: 0.18),
      unavailableColor = const Color(0xff64748b),
      tooltipBackgroundColor = AppColors.lightSurfaceRaised,
      notificationBackgroundColor = AppColors.lightSurfaceRaised,
      notificationBorderColor = AppColors.navy800.withValues(alpha: 0.16),
      bottomSheetHandleColor = AppColors.lightText.withValues(alpha: 0.2);

  AppTheme.dark()
    : textColor = AppColors.text,
      textColorDim = AppColors.textMuted,
      descriptionColor = AppColors.textMuted,
      iconColorDim = AppColors.textMuted.withValues(alpha: 0.72),
      selectedBackgroundColor = AppColors.blue.withValues(alpha: 0.12),
      availableColor = AppColors.green,
      availableBackgroundColor = AppColors.green.withValues(alpha: 0.1),
      predictionColor = AppColors.amber,
      predictionBackgroundColor = AppColors.amber.withValues(alpha: 0.1),
      unavailableColor = const Color(0xff71809b),
      tooltipBackgroundColor = AppColors.surfaceRaised,
      notificationBackgroundColor = AppColors.surfaceRaised,
      notificationBorderColor = AppColors.textMuted.withValues(alpha: 0.28),
      bottomSheetHandleColor = AppColors.text.withValues(alpha: 0.2);

  final Color textColor;
  final Color textColorDim;
  final Color descriptionColor;
  final Color iconColorDim;
  final Color selectedBackgroundColor;
  final Color availableColor;
  final Color availableBackgroundColor;
  final Color predictionColor;
  final Color predictionBackgroundColor;
  final Color unavailableColor;
  final Color tooltipBackgroundColor;
  final Color notificationBackgroundColor;
  final Color notificationBorderColor;
  final Color bottomSheetHandleColor;
}

extension BuildContextAppTheme on BuildContext {
  AppTheme get appTheme {
    final brightness = Theme.of(this).brightness;
    return switch (brightness) {
      .dark => .dark(),
      .light => .light(),
    };
  }
}
