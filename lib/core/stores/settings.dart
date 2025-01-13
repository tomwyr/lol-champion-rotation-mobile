import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/api_client.dart';
import '../model/notifications.dart';
import '../state.dart';

class SettingsStore {
  SettingsStore({
    required this.apiClient,
  });

  final AppApiClient apiClient;

  final ValueNotifier<SettingsState> state = ValueNotifier(Initial());
  final StreamController<SettingsEvent> events = StreamController.broadcast();

  var _isUpdating = false;

  void loadSettings() async {
    if (state.value case Loading()) {
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
    if (_isUpdating) {
      return;
    }

    final NotificationsSettings initialSettings;
    if (state.value case Data(value: var settings)) {
      initialSettings = settings;
    } else {
      return;
    }

    try {
      _isUpdating = true;

      final updatedSettings = initialSettings.copyWith(enabled: value);
      state.value = Data(updatedSettings);
      await apiClient.updateNotificationsSettings(updatedSettings);
    } catch (_) {
      state.value = Data(initialSettings);
      events.add(SettingsEvent.updateSettingsError);
    } finally {
      _isUpdating = false;
    }
  }
}

typedef SettingsState = DataState<NotificationsSettings>;

enum SettingsEvent {
  updateSettingsError,
}
