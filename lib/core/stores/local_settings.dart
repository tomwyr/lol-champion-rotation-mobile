import 'package:flutter/material.dart';

import '../../data/services/local_settings_service.dart';
import '../events.dart';
import '../model/common.dart';

class LocalSettingsStore {
  LocalSettingsStore({
    required this.appEvents,
    required this.settings,
  });

  final AppEvents appEvents;
  final LocalSettingsService settings;

  final initialized = ValueNotifier(false);
  final version = ValueNotifier('');
  final themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);
  final rotationViewType = ValueNotifier<RotationViewType>(RotationViewType.loose);
  final predictionsEnabled = ValueNotifier<bool>(false);
  final predictionsExpanded = ValueNotifier<bool>(false);

  void initialize() async {
    version.value = await settings.getVersion();
    themeMode.value = await settings.getThemeMode();
    rotationViewType.value = await settings.getRotationViewType();
    predictionsEnabled.value = await settings.getPredictionsEnabled();
    predictionsExpanded.value = await settings.getPredictionsExpanded();
    initialized.value = true;
  }

  void changeThemeMode(ThemeMode value) async {
    if (value == themeMode.value) {
      return;
    }
    await settings.saveThemeMode(value);
    themeMode.value = value;
  }

  void changeRotationViewType(RotationViewType value) async {
    if (value == rotationViewType.value) {
      return;
    }
    await settings.saveRotationViewType(value);
    rotationViewType.value = value;
  }

  void changePredictionsEnabled(bool value) async {
    if (value == predictionsEnabled.value) {
      return;
    }
    await settings.savePredictionsEnabled(value);
    predictionsEnabled.value = value;
    appEvents.predictionsEnabledChanged.notify();
  }

  void changePredictionsExpanded(bool value) async {
    if (value == predictionsExpanded.value) {
      return;
    }
    await settings.savePredictionsExpanded(value);
    predictionsExpanded.value = value;
  }
}
