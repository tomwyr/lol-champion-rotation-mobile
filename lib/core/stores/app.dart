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
  final predictionsEnabled = ValueNotifier<bool>(false);

  void initialize() async {
    version.value = await appSettings.getVersion();
    themeMode.value = await appSettings.getThemeMode();
    rotationViewType.value = await appSettings.getRotationViewType();
    predictionsEnabled.value = await appSettings.getPredictionsEnabled();
    initialized.value = true;
  }

  void changeThemeMode(ThemeMode value) async {
    if (value == themeMode.value) {
      return;
    }
    await appSettings.saveThemeMode(value);
    themeMode.value = value;
  }

  void changeRotationViewType(RotationViewType value) async {
    if (value == rotationViewType.value) {
      return;
    }
    await appSettings.saveRotationViewType(value);
    rotationViewType.value = value;
  }

  void changePredictionsEnabled(bool value) async {
    if (value == predictionsEnabled.value) {
      return;
    }
    await appSettings.savePredictionsEnabled(value);
    predictionsEnabled.value = value;
  }
}
