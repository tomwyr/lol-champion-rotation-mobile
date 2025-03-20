import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/api_client.dart';
import '../../data/services/permissions_service.dart';
import '../model/notifications.dart';
import '../state.dart';

class NotificationsSettingsStore {
  NotificationsSettingsStore({
    required this.apiClient,
    required this.permissions,
  });

  final AppApiClient apiClient;
  final PermissionsService permissions;

  final ValueNotifier<NotificationsSettingsState> state = ValueNotifier(Initial());
  final StreamController<NotificationsSettingsEvent> events = StreamController.broadcast();

  var _isUpdatingRotationChanged = false;
  var _isUpdatingChampionsAvailable = false;

  void initialize() async {
    if (state.value case Loading() || Data()) {
      return;
    }

    state.value = Loading();

    try {
      final result = await apiClient.notificationsSettings();
      state.value = Data(result);
    } catch (_) {
      events.add(NotificationsSettingsEvent.loadSettingsError);
      state.value = Error();
    }
  }

  void changeRotationChangedEnabled(bool value) async {
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
      state.value = Data(updatedSettings);
      await apiClient.updateNotificationsSettings(updatedSettings);
    } catch (_) {
      if (_currentSettings() case var settings?) {
        final restoredSettings = settings.copyWith(rotationChanged: !value);
        state.value = Data(restoredSettings);
      }
      events.add(NotificationsSettingsEvent.updateSettingsError);
    } finally {
      _isUpdatingRotationChanged = false;
    }
  }

  void changeChampionsAvailableEnabled(bool value) async {
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
      state.value = Data(updatedSettings);
      await apiClient.updateNotificationsSettings(updatedSettings);
    } catch (_) {
      if (_currentSettings() case var settings?) {
        final restoredSettings = settings.copyWith(championsAvailable: !value);
        state.value = Data(restoredSettings);
      }
      events.add(NotificationsSettingsEvent.updateSettingsError);
    } finally {
      _isUpdatingChampionsAvailable = false;
    }
  }

  NotificationsSettings? _currentSettings() {
    if (state.value case Data(value: var settings)) {
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

typedef NotificationsSettingsState = DataState<NotificationsSettings>;

enum NotificationsSettingsEvent {
  loadSettingsError,
  updateSettingsError,
  notificationsPermissionDenied,
}
