import 'package:flutter/material.dart';

import '../../core/stores/settings.dart';
import '../../dependencies/locate.dart';
import '../app/app_notifications.dart';
import '../common/widgets/events_listener.dart';
import 'settings_entries.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const SettingsPage(),
        ));
      },
      icon: const Icon(Icons.tune),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final store = locate<SettingsStore>();

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
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ThemeModeEntry(),
                SizedBox(height: 12),
                NotificationsSettingsEntry(),
                SizedBox(height: 12),
                PredictionsEnabledEntry(),
                SizedBox(height: 12),
                AppVersionEntry(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onEvent(SettingsEvent event, AppNotificationsState notifications) {
    switch (event) {
      case SettingsEvent.loadSettingsError:
        notifications.showError(
          message: 'Failed to load settings data.',
        );

      case SettingsEvent.updateSettingsError:
        notifications.showError(
          message: 'Could not update settings. Please try again.',
        );

      case SettingsEvent.notificationsPermissionDenied:
        notifications.showWarning(
          message: 'Grant permission in the system settings to receive notifications.',
        );
    }
  }
}
