import 'package:flutter/material.dart';

import '../../../common/base_cubit.dart';
import '../../../data/services/local_settings_service.dart';
import '../../events.dart';
import '../../model/common.dart';
import '../../model/local_settings.dart';
import 'local_settings_state.dart';

class LocalSettingsCubit extends BaseCubit<LocalSettingsState> {
  LocalSettingsCubit({required this.appEvents, required this.service}) : super(.initial());

  final AppEvents appEvents;
  final LocalSettingsService service;

  Future<void> initialize() async {
    final settings = await service.loadSettings();
    emit(.data(settings));
  }

  Future<void> changeThemeMode(ThemeMode value) async {
    if (value == state.settings.themeMode) {
      return;
    }

    await service.saveThemeMode(value);
    final updatedSettings = state.settings.copyWith(themeMode: value);
    emit(state.copyWith(settings: updatedSettings));
  }

  Future<void> changeRotationViewType(RotationViewType value) async {
    if (value == state.settings.rotationViewType) {
      return;
    }

    await service.saveRotationViewType(value);
    final updatedSettings = state.settings.copyWith(rotationViewType: value);
    emit(state.copyWith(settings: updatedSettings));
  }

  Future<void> changePredictionsEnabled(bool value) async {
    if (value == state.settings.predictionsEnabled) {
      return;
    }

    await service.savePredictionsEnabled(value);
    final updatedSettings = state.settings.copyWith(predictionsEnabled: value);
    emit(state.copyWith(settings: updatedSettings));
    appEvents.predictionsEnabledChanged.notify();
  }

  Future<void> changePredictionsExpanded(bool value) async {
    if (value == state.settings.predictionsExpanded) {
      return;
    }

    await service.savePredictionsExpanded(value);
    final updatedSettings = state.settings.copyWith(predictionsExpanded: value);
    emit(state.copyWith(settings: updatedSettings));
  }
}
