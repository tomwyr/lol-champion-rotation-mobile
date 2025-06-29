import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../../data/api_client.dart';
import '../../../data/services/permissions_service.dart';
import '../../model/notifications.dart';
import '../../state.dart';
import 'notifications_settings_state.dart';

part 'notifications_settings_store.g.dart';

class NotificationsSettingsStore extends _NotificationsSettingsStore
    with _$NotificationsSettingsStore {
  NotificationsSettingsStore({
    required super.apiClient,
    required super.permissions,
  });
}

abstract class _NotificationsSettingsStore with Store {
  _NotificationsSettingsStore({
    required this.apiClient,
    required this.permissions,
  });

  final AppApiClient apiClient;
  final PermissionsService permissions;

  @readonly
  NotificationsSettingsState _state = Initial();

  final StreamController<NotificationsSettingsEvent> events = StreamController.broadcast();

  var _isUpdatingRotationChanged = false;
  var _isUpdatingChampionsAvailable = false;

  @action
  Future<void> initialize() async {
    if (_state case Loading() || Data()) {
      return;
    }

    _state = Loading();

    try {
      final result = await apiClient.notificationsSettings();
      _state = Data(result);
    } catch (_) {
      events.add(NotificationsSettingsEvent.loadSettingsError);
      _state = Error();
    }
  }

  @action
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
      _state = Data(updatedSettings);
      await apiClient.updateNotificationsSettings(updatedSettings);
    } catch (_) {
      if (_currentSettings() case var settings?) {
        final restoredSettings = settings.copyWith(rotationChanged: !value);
        _state = Data(restoredSettings);
      }
      events.add(NotificationsSettingsEvent.updateSettingsError);
    } finally {
      _isUpdatingRotationChanged = false;
    }
  }

  @action
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
      _state = Data(updatedSettings);
      await apiClient.updateNotificationsSettings(updatedSettings);
    } catch (_) {
      if (_currentSettings() case var settings?) {
        final restoredSettings = settings.copyWith(championsAvailable: !value);
        _state = Data(restoredSettings);
      }
      events.add(NotificationsSettingsEvent.updateSettingsError);
    } finally {
      _isUpdatingChampionsAvailable = false;
    }
  }

  NotificationsSettings? _currentSettings() {
    if (_state case Data(value: var settings)) {
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
    if (permissionResult == RequestPermissionResult.denied) {
      events.add(NotificationsSettingsEvent.notificationsPermissionDenied);
    }
    return switch (permissionResult) {
      RequestPermissionResult.granted => true,
      RequestPermissionResult.denied || RequestPermissionResult.unknown => false
    };
  }
}
