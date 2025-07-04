import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/local_settings_service.dart';
import '../../events.dart';
import '../../model/common.dart';
import '../../model/local_settings.dart';
import 'local_settings_state.dart';

class LocalSettingsCubit extends Cubit<LocalSettingsState> {
  LocalSettingsCubit({
    required this.appEvents,
    required this.service,
  }) : super(LocalSettingsState.initial());

  final AppEvents appEvents;
  final LocalSettingsService service;

  Future<void> initialize() async {
    final settings = await service.loadSettings();
    emit(LocalSettingsState.data(settings));
  }

  Future<void> changeThemeMode(ThemeMode value) async {
    if (value == state.settings.themeMode) {
      return;
    }

    await service.saveThemeMode(value);
    final updatedSettings = state.settings.copyWith(themeMode: value);
    emit(LocalSettingsState.data(updatedSettings));
  }

  Future<void> changeRotationViewType(RotationViewType value) async {
    if (value == state.settings.rotationViewType) {
      return;
    }

    await service.saveRotationViewType(value);
    final updatedSettings = state.settings.copyWith(rotationViewType: value);
    emit(LocalSettingsState.data(updatedSettings));
  }

  Future<void> changePredictionsEnabled(bool value) async {
    if (value == state.settings.predictionsEnabled) {
      return;
    }

    await service.savePredictionsEnabled(value);
    final updatedSettings = state.settings.copyWith(predictionsEnabled: value);
    emit(LocalSettingsState.data(updatedSettings));
  }

  Future<void> changePredictionsExpanded(bool value) async {
    if (value == state.settings.predictionsExpanded) {
      return;
    }

    await service.savePredictionsExpanded(value);
    final updatedSettings = state.settings.copyWith(predictionsExpanded: value);
    emit(LocalSettingsState.data(updatedSettings));
  }
}
