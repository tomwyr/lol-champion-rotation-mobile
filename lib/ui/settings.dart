import 'dart:async';

import 'package:flutter/material.dart';

import '../core/model/notifications.dart';
import '../core/state.dart';
import '../core/stores/app.dart';
import '../core/stores/settings.dart';
import '../dependencies.dart';
import 'app.dart';
import 'widgets/data_error.dart';
import 'widgets/data_loading.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => const SettingsDialog(),
        );
      },
      icon: const Icon(Icons.tune),
    );
  }
}

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  final store = locate<SettingsStore>();

  late StreamSubscription eventsSubscription;

  AppNotifications get notifications => AppNotifications.of(context);

  @override
  void initState() {
    super.initState();
    store.loadSettings();
    eventsSubscription = store.events.stream.listen(onEvent);
  }

  @override
  void dispose() {
    eventsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ValueListenableBuilder(
          valueListenable: store.state,
          builder: (context, value, _) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Settings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              switch (value) {
                Initial() || Loading() => const DataLoading(),
                Error() => const DataError(
                    message: 'Failed to load settings data.',
                  ),
                Data(:var value) => settingsContent(value),
              },
            ],
          ),
        ),
      ),
    );
  }

  Widget settingsContent(NotificationsSettings settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NotificationsSettingsEntry(settings: settings),
        const SizedBox(height: 8),
        const AppVersionEntry(),
      ],
    );
  }

  void onEvent(SettingsEvent event) {
    switch (event) {
      case SettingsEvent.updateSettingsError:
        notifications.showError(
          message: 'Could not update settings. Please try again.',
        );

      case SettingsEvent.notificationsPermissionDenied:
        notifications.showWarning(
          message: 'Grant permission in the system settings to receive notifications',
        );
    }
  }
}

class NotificationsSettingsEntry extends StatelessWidget {
  const NotificationsSettingsEntry({
    super.key,
    required this.settings,
  });

  final NotificationsSettings settings;

  SettingsStore get store => locate();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: SettingsEntry(
            title: 'Notifications',
            description: 'Receive notifications whenever the free champions rotation changes.',
          ),
        ),
        Switch(
          value: settings.enabled,
          onChanged: store.toggleNotificationsEnabled,
        ),
      ],
    );
  }
}

class AppVersionEntry extends StatelessWidget {
  const AppVersionEntry({super.key});

  AppStore get store => locate();

  @override
  Widget build(BuildContext context) {
    return SettingsEntry(
      title: 'App version',
      description: store.version.value,
    );
  }
}

class SettingsEntry extends StatelessWidget {
  const SettingsEntry({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
              ),
        ),
      ],
    );
  }
}
