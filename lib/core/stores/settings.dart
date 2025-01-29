import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/api_client.dart';
import '../../data/permissions_service.dart';
import '../model/notifications.dart';
import '../state.dart';

class SettingsStore {
  SettingsStore({
    required this.apiClient,
    required this.permissions,
  });

  final AppApiClient apiClient;
  final PermissionsService permissions;

  final ValueNotifier<SettingsState> state = ValueNotifier(Initial());
  final StreamController<SettingsEvent> events = StreamController.broadcast();

  var _isUpdating = false;

  void initialize() async {
    if (state.value case Loading() || Data()) {
      return;
    }

    state.value = Loading();

    try {
      final result = await apiClient.notificationsSettings();
      state.value = Data(result);
    } catch (_) {
      state.value = Error();
    }
  }

  void toggleNotificationsEnabled(bool value) async {
    final initialSettings = _assertIdleState();
    if (initialSettings == null) {
      return;
    }

    try {
      _isUpdating = true;

      if (await _verifySettingsBeforeUpdate(initialSettings, value)) {
        final updatedSettings = initialSettings.copyWith(enabled: value);
        state.value = Data(updatedSettings);
        await apiClient.updateNotificationsSettings(updatedSettings);
      }
    } catch (_) {
      state.value = Data(initialSettings);
      events.add(SettingsEvent.updateSettingsError);
    } finally {
      _isUpdating = false;
    }
  }

  Future<bool> _verifySettingsBeforeUpdate(
    NotificationsSettings currentSettings,
    bool notificationsEnabled,
  ) async {
    if (!notificationsEnabled) {
      return true;
    }

    final permissionResult = await permissions.requestNotificationsPermission();
    switch (permissionResult) {
      case RequestPermissionResult.granted:
        return true;

      case RequestPermissionResult.denied:
        state.value = Data(currentSettings);
        events.add(SettingsEvent.notificationsPermissionDenied);
        return false;

      case RequestPermissionResult.unknown:
        state.value = Data(currentSettings);
        return false;
    }
  }

  NotificationsSettings? _assertIdleState() {
    if (_isUpdating) {
      return null;
    }

    if (state.value case Data(value: var settings)) {
      return settings;
    } else {
      return null;
    }
  }
}

typedef SettingsState = DataState<NotificationsSettings>;

enum SettingsEvent {
  updateSettingsError,
  notificationsPermissionDenied,
}
