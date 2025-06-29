import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../data/services/local_settings_service.dart';
import '../events.dart';
import '../model/common.dart';

part 'local_settings_store.g.dart';

class LocalSettingsStore extends _LocalSettingsStore with _$LocalSettingsStore {
  LocalSettingsStore({
    required super.appEvents,
    required super.settings,
  });
}

abstract class _LocalSettingsStore with Store {
  _LocalSettingsStore({
    required this.appEvents,
    required this.settings,
  });

  final AppEvents appEvents;
  final LocalSettingsService settings;

  @readonly
  var _initialized = false;

  @readonly
  var _version = '';

  @readonly
  var _themeMode = ThemeMode.system;

  @readonly
  var _rotationViewType = RotationViewType.compact;

  @readonly
  var _predictionsEnabled = false;

  @readonly
  var _predictionsExpanded = false;

  @action
  Future<void> initialize() async {
    _version = await settings.getVersion();
    _themeMode = await settings.getThemeMode();
    _rotationViewType = await settings.getRotationViewType();
    _predictionsEnabled = await settings.getPredictionsEnabled();
    _predictionsExpanded = await settings.getPredictionsExpanded();
    _initialized = true;
  }

  @action
  Future<void> changeThemeMode(ThemeMode value) async {
    if (value == _themeMode) {
      return;
    }
    await settings.saveThemeMode(value);
    _themeMode = value;
  }

  @action
  Future<void> changeRotationViewType(RotationViewType value) async {
    if (value == _rotationViewType) {
      return;
    }
    await settings.saveRotationViewType(value);
    _rotationViewType = value;
  }

  @action
  Future<void> changePredictionsEnabled(bool value) async {
    if (value == _predictionsEnabled) {
      return;
    }
    await settings.savePredictionsEnabled(value);
    _predictionsEnabled = value;
    appEvents.predictionsEnabledChanged.notify();
  }

  @action
  Future<void> changePredictionsExpanded(bool value) async {
    if (value == _predictionsExpanded) {
      return;
    }
    await settings.savePredictionsExpanded(value);
    _predictionsExpanded = value;
  }
}
