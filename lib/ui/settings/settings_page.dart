import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/application/notifications_settings/notifications_settings_cubit.dart';
import '../../core/application/notifications_settings/notifications_settings_state.dart';
import '../app/app_notifications.dart';
import '../common/utils/routes.dart';
import '../common/widgets/events_listener.dart';
import '../common/widgets/lifecycle.dart';
import 'settings_entries.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static void push(BuildContext context) {
    context.pushDefaultRoute(const SettingsPage());
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsSettingsCubit>();

    return Lifecycle(
      onInit: cubit.initialize,
      child: EventsListener(
        events: cubit.events.stream,
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
