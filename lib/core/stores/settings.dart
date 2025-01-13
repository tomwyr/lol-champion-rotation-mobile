import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/api_client.dart';
import '../../data/fcm_token.dart';
import '../model/notifications.dart';
import '../state.dart';

class SettingsStore {
  SettingsStore({
    required this.apiClient,
    required this.fcmToken,
  });

  final AppApiClient apiClient;
  final FcmTokenService fcmToken;

  final ValueNotifier<SettingsState> state = ValueNotifier(Initial());
  final StreamController<SettingsEvent> events = StreamController.broadcast();

  var _isUpdating = false;

  void loadSettings() async {
    if (state.value case Loading()) {
      return;
    }

    state.value = Loading();

    try {
      final deviceId = await fcmToken.getDeviceId();
      final result = await apiClient.notificationsSettings(deviceId);
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
      final deviceId = await fcmToken.getDeviceId();

      final updatedSettings = initialSettings.copyWith(enabled: value);
      state.value = Data(updatedSettings);

      final result = await apiClient.updateNotificationsSettings(deviceId, updatedSettings);
      state.value = Data(result);
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
