import 'package:flutter/material.dart';

import '../../core/model/notifications.dart';
import '../../core/state.dart';
import '../../core/stores/app.dart';
import '../../core/stores/settings.dart';
import '../../dependencies.dart';
import '../common/theme.dart';
import '../common/widgets/app_dialog.dart';
import '../common/widgets/data_loading.dart';

class ThemeModeEntry extends StatelessWidget {
  const ThemeModeEntry({super.key});

  AppStore get store => locate();

  @override
  Widget build(BuildContext context) {
    return SettingsEntry(
      title: 'Dark mode',
      description: "Customize the app's appearance with your preferred theme setting.",
      trailing: ValueListenableBuilder(
        valueListenable: store.themeMode,
        builder: (context, value, _) => OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(96, 40),
          ),
          onPressed: () => ThemeModeDialog.show(
            context,
            initialValue: value,
            onChanged: store.changeThemeMode,
          ),
          child: Text(switch (value) {
            ThemeMode.system => 'System',
            ThemeMode.light => 'Light',
            ThemeMode.dark => 'Dark',
          }),
        ),
      ),
    );
  }
}

class ThemeModeDialog extends StatelessWidget {
  const ThemeModeDialog({
    super.key,
    required this.initialValue,
  });

  final ThemeMode? initialValue;

  static Future<void> show(
    BuildContext context, {
    required ThemeMode initialValue,
    required ValueChanged<ThemeMode> onChanged,
  }) async {
    final result = await showModalBottomSheet<ThemeMode>(
      context: context,
      builder: (context) => ThemeModeDialog(initialValue: initialValue),
    );
    if (result != null && result != initialValue) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppSelectionDialog(
      title: 'Dark mode',
      initialValue: initialValue,
      items: const [
        AppSelectionItem(
          value: ThemeMode.system,
          title: 'System',
          description: 'Matches your device',
        ),
        AppSelectionItem(
          value: ThemeMode.light,
          title: 'Light',
          description: 'Bright and clear',
        ),
        AppSelectionItem(
          value: ThemeMode.dark,
          title: 'Dark',
          description: 'Easy on the eyes',
        ),
      ],
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
      child = ColoredBox(
        color: context.appTheme.selectedBackgroundColor,
        child: child,
      );
    }

    return child;
  }
}

class NotificationsSettingsEntry extends StatelessWidget {
  const NotificationsSettingsEntry({
    super.key,
  });

  SettingsStore get store => locate();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: store.state,
      builder: (context, value, _) => switch (value) {
        Initial() || Loading() => const DataLoading(),
        Error() => const SizedBox.shrink(),
        Data(:var value) => settingsEntry(value),
      },
    );
  }

  Widget settingsEntry(NotificationsSettings settings) {
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
