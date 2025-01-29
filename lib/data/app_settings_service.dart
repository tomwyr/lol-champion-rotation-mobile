import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsService {
  AppSettingsService({required this.sharedPrefs});

  final SharedPreferencesAsync sharedPrefs;

  static const _useDarkModeKey = 'PREFERENCES_USE_DARK_MODE';

  Future<String> getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<ThemeMode> getThemeMode() async {
    final useDarkMode = await sharedPrefs.getBool(_useDarkModeKey);
    return switch (useDarkMode) {
      true => ThemeMode.light,
      false => ThemeMode.dark,
      null => ThemeMode.system,
    };
  }

  Future<void> saveThemeMode(ThemeMode value) async {
    final useDarkMode = switch (value) {
      ThemeMode.light => true,
      ThemeMode.dark => false,
      ThemeMode.system => null,
    };
    if (useDarkMode != null) {
      await sharedPrefs.setBool(_useDarkModeKey, useDarkMode);
    } else {
      await sharedPrefs.remove(_useDarkModeKey);
    }
  }
}
