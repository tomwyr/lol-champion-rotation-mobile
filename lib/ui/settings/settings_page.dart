import 'package:flutter/material.dart';

import '../../core/stores/notifications_settings/notifications_settings_state.dart';
import '../../core/stores/notifications_settings/notifications_settings_store.dart';
import '../../dependencies/locate.dart';
import '../app/app_notifications.dart';
import '../common/widgets/events_listener.dart';
import 'settings_entries.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final store = locate<NotificationsSettingsStore>();

  @override
  void initState() {
    super.initState();
    store.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return EventsListener(
      events: store.events.stream,
      onEvent: onEvent,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: const SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ThemeModeEntry(),
              RotationViewTypeEntry(),
              PredictionsEnabledEntry(),
              NotificationsSettingsEntry(),
            ],
          ),
        ),
      ),
    );
  }

  void onEvent(NotificationsSettingsEvent event, AppNotificationsState notifications) {
    switch (event) {
      case NotificationsSettingsEvent.loadSettingsError:
        notifications.showError(
          message: 'Failed to load settings data.',
        );

      case NotificationsSettingsEvent.updateSettingsError:
        notifications.showError(
          message: 'Could not update settings. Please try again.',
        );

      case NotificationsSettingsEvent.notificationsPermissionDenied:
        notifications.showWarning(
          message: 'Grant permission in the system settings to receive notifications.',
        );
    }
  }
}
