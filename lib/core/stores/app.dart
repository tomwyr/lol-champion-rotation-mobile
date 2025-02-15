import 'package:flutter/material.dart';

import '../../data/app_settings_service.dart';
import '../model/common.dart';

class AppStore {
  AppStore({
    required this.appSettings,
  });

  final AppSettingsService appSettings;

  final initialized = ValueNotifier(false);
  final version = ValueNotifier('');
  final themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);
  final rotationViewType = ValueNotifier<RotationViewType>(RotationViewType.loose);

  void initialize() async {
    version.value = await appSettings.getVersion();
    themeMode.value = await appSettings.getThemeMode();
    rotationViewType.value = await appSettings.getRotationViewType();
    initialized.value = true;
  }

  void changeThemeMode(ThemeMode value) async {
    await appSettings.saveThemeMode(value);
    themeMode.value = value;
  }

  void changeRotationViewType(RotationViewType value) async {
    await appSettings.saveRotationViewType(value);
    rotationViewType.value = value;
  }
}
