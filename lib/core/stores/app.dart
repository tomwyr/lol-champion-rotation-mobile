import 'package:flutter/material.dart';

import '../../data/app_settings_service.dart';
import '../../data/update_service.dart';
import '../events.dart';
import '../model/common.dart';

class AppStore {
  AppStore({
    required this.appEvents,
    required this.appSettings,
    required this.updateService,
  });

  final AppEvents appEvents;
  final AppSettingsService appSettings;
  final UpdateService updateService;

  final initialized = ValueNotifier(false);
  final version = ValueNotifier('');
  final themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);
  final rotationViewType = ValueNotifier<RotationViewType>(RotationViewType.loose);
  final predictionsEnabled = ValueNotifier<bool>(false);
  final predictionsExpanded = ValueNotifier<bool>(false);

  void initialize() async {
    promptUpdateIfAvailable();
    await initializeSettings();
    initialized.value = true;
  }

  void promptUpdateIfAvailable() async {
    final status = await updateService.checkUpdateStatus();
    if (status == UpdateStatus.available) {
      await updateService.installUpdate();
    }
  }

  Future<void> initializeSettings() async {
    version.value = await appSettings.getVersion();
    themeMode.value = await appSettings.getThemeMode();
    rotationViewType.value = await appSettings.getRotationViewType();
    predictionsEnabled.value = await appSettings.getPredictionsEnabled();
    predictionsExpanded.value = await appSettings.getPredictionsExpanded();
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
    appEvents.predictionsEnabledChanged.notify();
  }

  void changePredictionsExpanded(bool value) async {
    if (value == predictionsExpanded.value) {
      return;
    }
    await appSettings.savePredictionsExpanded(value);
    predictionsExpanded.value = value;
  }
}
