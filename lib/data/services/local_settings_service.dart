import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/model/common.dart';
import '../../core/model/local_settings.dart';

class LocalSettingsService {
  LocalSettingsService({required this.sharedPrefs});

  final SharedPreferencesAsync sharedPrefs;

  static const _useDarkModeKey = 'APP_USE_DARK_MODE';
  static const _rotationViewTypeKey = 'APP_ROTATION_VIEW_TYPE';
  static const _predictionsEnabledKey = 'APP_PREDICTIONS_ENABLED';
  static const _predictionsExpandedKey = 'APP_PREDICTIONS_EXPANDED';

  Future<LocalSettings> loadSettings() async {
    return LocalSettings(
      themeMode: await getThemeMode(),
      rotationViewType: await getRotationViewType(),
      predictionsEnabled: await getPredictionsEnabled(),
      predictionsExpanded: await getPredictionsExpanded(),
    );
  }

  Future<String> getAppVersion() async {
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

  Future<RotationViewType> getRotationViewType() async {
    RotationViewType? result;
    final rawValue = await sharedPrefs.getString(_rotationViewTypeKey);
    if (rawValue != null) {
      result = RotationViewType.fromName(rawValue);
    }
    return result ?? RotationViewType.compact;
  }

  Future<void> saveRotationViewType(RotationViewType value) async {
    await sharedPrefs.setString(_rotationViewTypeKey, value.name);
  }

  Future<bool> getPredictionsEnabled() async {
    final predictionsEnabled = await sharedPrefs.getBool(_predictionsEnabledKey);
    return predictionsEnabled ?? false;
  }

  Future<void> savePredictionsEnabled(bool value) async {
    await sharedPrefs.setBool(_predictionsEnabledKey, value);
  }

  Future<bool> getPredictionsExpanded() async {
    final predictionsExpanded = await sharedPrefs.getBool(_predictionsExpandedKey);
    return predictionsExpanded ?? true;
  }

  Future<void> savePredictionsExpanded(bool value) async {
    await sharedPrefs.setBool(_predictionsExpandedKey, value);
  }
}
