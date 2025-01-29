import 'package:flutter/material.dart';

import '../../data/app_settings_service.dart';

class AppStore {
  AppStore({
    required this.appSettings,
  });

  final AppSettingsService appSettings;

  final initialized = ValueNotifier(false);
  final version = ValueNotifier('');
  final themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);

  void initialize() async {
    version.value = await appSettings.getVersion();
    themeMode.value = await appSettings.getThemeMode();
    initialized.value = true;
  }

  void changeThemeMode(ThemeMode value) async {
    await appSettings.saveThemeMode(value);
    themeMode.value = value;
  }
}
