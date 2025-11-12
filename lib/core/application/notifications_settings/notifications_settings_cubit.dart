import 'dart:async';

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

  var _isUpdatingRotationChanged = false;
  var _isUpdatingChampionsAvailable = false;

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
    final permissionValid = await _verifyPermissionsBeforeUpdate(value);
    if (_isUpdatingRotationChanged || !permissionValid) {
      return;
    }
    final currentSettings = _currentSettings();
    if (currentSettings == null || currentSettings.rotationChanged == value) {
      return;
    }

    try {
      _isUpdatingRotationChanged = true;

      final updatedSettings = currentSettings.copyWith(rotationChanged: value);
      emit(Data(updatedSettings));
      await apiClient.updateNotificationsSettings(updatedSettings);
    } catch (_) {
      if (_currentSettings() case var settings?) {
        final restoredSettings = settings.copyWith(rotationChanged: !value);
        emit(Data(restoredSettings));
      }
      events.add(.updateSettingsError);
    } finally {
      _isUpdatingRotationChanged = false;
    }
  }

  Future<void> changeChampionsAvailableEnabled(bool value) async {
    final permissionValid = await _verifyPermissionsBeforeUpdate(value);
    if (_isUpdatingChampionsAvailable || !permissionValid) {
      return;
    }
    final currentSettings = _currentSettings();
    if (currentSettings == null || currentSettings.championsAvailable == value) {
      return;
    }

    try {
      _isUpdatingChampionsAvailable = true;

      final updatedSettings = currentSettings.copyWith(championsAvailable: value);
      emit(Data(updatedSettings));
      await apiClient.updateNotificationsSettings(updatedSettings);
    } catch (_) {
      if (_currentSettings() case var settings?) {
        final restoredSettings = settings.copyWith(championsAvailable: !value);
        emit(Data(restoredSettings));
      }
      events.add(.updateSettingsError);
    } finally {
      _isUpdatingChampionsAvailable = false;
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
