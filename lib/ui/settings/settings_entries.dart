import 'package:flutter/material.dart';

import '../../core/model/common.dart';
import '../../core/model/notifications.dart';
import '../../core/state.dart';
import '../../core/stores/local_settings.dart';
import '../../core/stores/notifications_settings.dart';
import '../../dependencies/locate.dart';
import '../common/theme.dart';
import '../common/widgets/app_dialog.dart';
import '../common/widgets/data_states.dart';
import '../common/widgets/list_entry.dart';
import '../rotation/selectors/rotation_view_type.dart';

class ThemeModeEntry extends StatelessWidget {
  const ThemeModeEntry({super.key});

  LocalSettingsStore get store => locate();

  @override
  Widget build(BuildContext context) {
    return ListEntry(
      title: 'Dark mode',
      description: "Customize the app's appearance with your preferred theme setting.",
      trailing: ValueListenableBuilder(
        valueListenable: store.themeMode,
        builder: (context, value, _) => _EntryValueButton(
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

class RotationViewTypeEntry extends StatelessWidget {
  const RotationViewTypeEntry({super.key});

  LocalSettingsStore get store => locate();

  @override
  Widget build(BuildContext context) {
    return ListEntry(
      title: 'Rotation view type',
      description: 'Choose the display density for the rotation champions list.',
      trailing: ValueListenableBuilder(
        valueListenable: store.rotationViewType,
        builder: (context, value, child) => _EntryValueButton(
          onPressed: () => RotationViewTypeDialog.show(
            context,
            initialValue: value,
            onChanged: store.changeRotationViewType,
          ),
          child: Text(switch (value) {
            RotationViewType.loose => 'Comfort',
            RotationViewType.compact => 'Compact',
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

  NotificationsSettingsStore get store => locate();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: store.state,
      builder: (context, value, _) => switch (value) {
        Initial() || Loading() => const DataLoading(expand: false),
        Error() => const SizedBox.shrink(),
        Data(:var value) => settingsEntry(value),
      },
    );
  }

  Widget settingsEntry(NotificationsSettings settings) {
    return ListEntry(
      title: 'Notifications',
      description: 'Receive notifications whenever the free champions rotation changes.',
      trailing: Switch(
        value: settings.enabled,
        onChanged: store.toggleNotificationsEnabled,
      ),
    );
  }
}

class PredictionsEnabledEntry extends StatelessWidget {
  const PredictionsEnabledEntry({super.key});

  LocalSettingsStore get store => locate();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: store.predictionsEnabled,
      builder: (context, value, _) => ListEntry(
        title: 'Predictions',
        description:
            'Display upcoming champion rotations based on patterns from previous rotations.',
        trailing: Switch(
          value: value,
          onChanged: store.changePredictionsEnabled,
        ),
      ),
    );
  }
}

class _EntryValueButton extends StatelessWidget {
  const _EntryValueButton({required this.onPressed, required this.child});

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(96, 40),
        padding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
