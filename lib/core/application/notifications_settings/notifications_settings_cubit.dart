import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../common/base_cubit.dart';
import '../../../data/api_client.dart';
import '../../../data/services/permissions_service.dart';
import '../../model/notifications.dart';
import '../../state.dart';
import 'notifications_settings_state.dart';

class NotificationsSettingsCubit extends BaseCubit<NotificationsSettingsState> {
  NotificationsSettingsCubit({required this.apiClient, required this.permissions})
    : super(Initial());

  final AppApiClient apiClient;
  final PermissionsService permissions;

  final StreamController<NotificationsSettingsEvent> events = .broadcast();

  final _isUpdatingRotationChanged = ValueNotifier(false);
  final _isUpdatingChampionsAvailable = ValueNotifier(false);
  final _isUpdatingChampionReleased = ValueNotifier(false);

  Future<void> initialize() async {
    if (state case Loading() || Data()) {
      return;
    }

    emit(Loading());

    try {
      final result = await apiClient.notificationsSettings();
      emit(Data(result));
    } catch (_) {
      events.add(.loadSettingsError);
      emit(Error());
    }
  }

  Future<void> changeRotationChangedEnabled(bool value) async {
    await _updateSettingEnabled(
      value: value,
      isUpdating: _isUpdatingRotationChanged,
      currentValue: (settings) => settings.rotationChanged,
      updateValue: (settings, value) => settings.copyWith(rotationChanged: value),
    );
  }

  Future<void> changeChampionsAvailableEnabled(bool value) async {
    await _updateSettingEnabled(
      value: value,
      isUpdating: _isUpdatingChampionsAvailable,
      currentValue: (settings) => settings.championsAvailable,
      updateValue: (settings, value) => settings.copyWith(championsAvailable: value),
    );
  }

  Future<void> changeChampionReleasedEnabled(bool value) async {
    await _updateSettingEnabled(
      value: value,
      isUpdating: _isUpdatingChampionReleased,
      currentValue: (settings) => settings.championReleased,
      updateValue: (settings, value) => settings.copyWith(championReleased: value),
    );
  }

  Future<void> _updateSettingEnabled({
    required bool value,
    required ValueNotifier<bool> isUpdating,
    required bool Function(NotificationsSettings) currentValue,
    required NotificationsSettings Function(NotificationsSettings, bool value) updateValue,
  }) async {
    final permissionValid = await _verifyPermissionsBeforeUpdate(value);
    if (isUpdating.value || !permissionValid) {
      return;
    }
    final currentSettings = _currentSettings();
    if (currentSettings == null || currentValue(currentSettings) == value) {
      return;
    }

    try {
      isUpdating.value = true;
      final updatedSettings = updateValue(currentSettings, value);
      emit(Data(updatedSettings));
      await apiClient.updateNotificationsSettings(updatedSettings);
    } catch (_) {
      if (_currentSettings() case var settings?) {
        final restoredSettings = updateValue(settings, !value);
        emit(Data(restoredSettings));
      }
      events.add(.updateSettingsError);
    } finally {
      isUpdating.value = false;
    }
  }

  NotificationsSettings? _currentSettings() {
    if (state case Data(value: var settings)) {
      return settings;
    } else {
      return null;
    }
  }

  Future<bool> _verifyPermissionsBeforeUpdate(bool settingEnabled) async {
    if (!settingEnabled) {
      return true;
    }

    final permissionResult = await permissions.requestNotificationsPermission();
    if (permissionResult == .denied) {
      events.add(.notificationsPermissionDenied);
    }
    return switch (permissionResult) {
      .granted => true,
      .denied || .unknown => false,
    };
  }
}
