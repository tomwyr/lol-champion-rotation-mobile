import 'dart:async';

import 'package:flutter/material.dart';

import '../core/model/notifications.dart';
import '../core/state.dart';
import '../core/stores/app.dart';
import '../core/stores/settings.dart';
import '../dependencies.dart';
import 'app.dart';
import 'theme.dart';
import 'widgets/data_error.dart';
import 'widgets/data_loading.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ValueListenableBuilder(
            valueListenable: store.state,
            builder: (context, value, _) => switch (value) {
              Initial() || Loading() => const DataLoading(),
              Error() => const DataError(
                  message: 'Failed to load settings data.',
                ),
              Data(:var value) => settingsContent(value),
            },
          ),
        ),
      ),
    );
  }

  Widget settingsContent(NotificationsSettings settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ThemeModeEntry(),
        const SizedBox(height: 12),
        NotificationsSettingsEntry(settings: settings),
        const SizedBox(height: 12),
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

class ThemeModeEntry extends StatelessWidget {
  const ThemeModeEntry({super.key});

  AppStore get store => locate();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: store.themeMode,
      builder: (context, value, _) => SettingsEntry(
        title: 'Dark mode',
        description: "Customize the app's appearance with your preferred theme setting.",
        trailing: OutlinedButton(
          onPressed: () => showPicker(context, value),
          child: Text(switch (value) {
            ThemeMode.system => 'System',
            ThemeMode.light => 'Light',
            ThemeMode.dark => 'Dark',
          }),
        ),
      ),
    );
  }

  void showPicker(BuildContext context, ThemeMode currentValue) async {
    final result = await showModalBottomSheet<ThemeMode>(
      context: context,
      builder: (context) => ThemeModeDialog(value: currentValue),
    );

    if (result != null && result != currentValue) {
      store.changeThemeMode(result);
    }
  }
}

class ThemeModeDialog extends StatelessWidget {
  const ThemeModeDialog({
    super.key,
    required this.value,
  });

  final ThemeMode? value;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Dark mode',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 12),
            systemEntry(context),
            lightEntry(context),
            darkEntry(context),
          ],
        ),
      ),
    );
  }

  Widget systemEntry(BuildContext context) {
    return ThemeModeTile(
      title: 'System',
      description: 'Matches your device',
      selected: value == ThemeMode.system,
      onTap: () => Navigator.of(context).pop(ThemeMode.system),
    );
  }

  Widget lightEntry(BuildContext context) {
    return ThemeModeTile(
      title: 'Light',
      description: 'Bright and clear',
      selected: value == ThemeMode.light,
      onTap: () => Navigator.of(context).pop(ThemeMode.light),
    );
  }

  Widget darkEntry(BuildContext context) {
    return ThemeModeTile(
      title: 'Dark',
      description: 'Easy on the eyes',
      selected: value == ThemeMode.dark,
      onTap: () => Navigator.of(context).pop(ThemeMode.dark),
    );
  }
}

class ThemeModeTile extends StatelessWidget {
  const ThemeModeTile({
    super.key,
    required this.title,
    required this.description,
    required this.selected,
    this.onTap,
  });

  final String title;
  final String description;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget child;

    child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
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
                        color: context.appTheme.descriptionColor,
                      ),
                ),
              ],
            ),
          ),
          if (selected) const Icon(Icons.check),
        ],
      ),
    );

    if (onTap != null) {
      child = InkWell(onTap: onTap, child: child);
    }
    if (selected) {
      child = ColoredBox(color: Colors.black12, child: child);
    }

    return child;
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
    return SettingsEntry(
      title: 'Notifications',
      description: 'Receive notifications whenever the free champions rotation changes.',
      trailing: Switch(
        value: settings.enabled,
        onChanged: store.toggleNotificationsEnabled,
      ),
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
    this.trailing,
  });

  final String title;
  final String description;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final content = Column(
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
                color: context.appTheme.descriptionColor,
              ),
        ),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: content,
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          trailing!,
        ],
      ],
    );
  }
}
