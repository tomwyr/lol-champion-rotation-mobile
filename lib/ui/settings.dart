import 'dart:async';

import 'package:flutter/material.dart';

import '../core/model/notifications.dart';
import '../core/stores/settings.dart';
import '../core/state.dart';
import '../dependencies.dart';
import 'notifications.dart';
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder(
              valueListenable: store.state,
              builder: (context, value, _) {
                return switch (value) {
                  Initial() || Loading() => const DataLoading(
                      message: 'Loading ...',
                    ),
                  Error() => const DataError(
                      message: 'Failed to load settings data.',
                    ),
                  Data(:var value) => SettingsData(settings: value),
                };
              },
            ),
          ],
        ),
      ),
    );
  }

  void onEvent(SettingsEvent event) {
    final notifications = AppNotifications.of(context);

    switch (event) {
      case SettingsEvent.updateSettingsError:
        notifications.showError(
          message: 'Could not update settings. Please try again.',
        );
    }
  }
}

class SettingsData extends StatelessWidget {
  const SettingsData({
    super.key,
    required this.settings,
  });

  final NotificationsSettings settings;

  SettingsStore get store => locate<SettingsStore>();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Receive notifications whenever the free champions rotation changes.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
              ),
            ],
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
