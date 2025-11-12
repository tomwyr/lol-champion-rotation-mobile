import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/application/local_settings/local_settings_cubit.dart';
import '../../core/application/notifications_settings/notifications_settings_cubit.dart';
import '../../core/model/notifications.dart';
import '../../core/state.dart';
import '../common/theme.dart';
import '../common/widgets/app_bottom_sheet.dart';
import '../common/widgets/app_selection_sheet.dart';
import '../common/widgets/data_states.dart';
import '../common/widgets/list_entry.dart';
import '../rotation_list/selectors/rotation_view_type.dart';

class ThemeModeEntry extends StatelessWidget {
  const ThemeModeEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final changeThemeMode = context.read<LocalSettingsCubit>().changeThemeMode;
    final themeMode = context.select((LocalSettingsCubit cubit) => cubit.state.settings.themeMode);

    return ListEntry(
      title: 'Dark mode',
      description: "Customize the app's appearance with your preferred theme setting.",
      trailing: _EntryValueButton(
        onPressed: () =>
            ThemeModeDialog.show(context, initialValue: themeMode, onChanged: changeThemeMode),
        child: Text(switch (themeMode) {
          .system => 'System',
          .light => 'Light',
          .dark => 'Dark',
        }),
      ),
    );
  }
}

class RotationViewTypeEntry extends StatelessWidget {
  const RotationViewTypeEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final rotationViewType = context.select(
      (LocalSettingsCubit cubit) => cubit.state.settings.rotationViewType,
    );
    final changeViewType = context.read<LocalSettingsCubit>().changeRotationViewType;

    return ListEntry(
      title: 'Rotation view type',
      description: 'Choose the display density for the rotation champions list.',
      trailing: _EntryValueButton(
        onPressed: () => RotationViewTypeDialog.show(
          context,
          initialValue: rotationViewType,
          onChanged: changeViewType,
        ),
        child: Text(switch (rotationViewType) {
          .loose => 'Comfort',
          .compact => 'Compact',
        }),
      ),
    );
  }
}

class ThemeModeDialog extends StatelessWidget {
  const ThemeModeDialog({super.key, required this.initialValue});

  final ThemeMode? initialValue;

  static Future<void> show(
    BuildContext context, {
    required ThemeMode initialValue,
    required ValueChanged<ThemeMode> onChanged,
  }) async {
    final result = await AppBottomSheet.show<ThemeMode>(
      context: context,
      builder: (context) => ThemeModeDialog(initialValue: initialValue),
    );
    if (result != null && result != initialValue) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppSelectionSheet(
      title: 'Dark mode',
      initialValue: initialValue,
      items: const <AppSelectionItem<ThemeMode>>[
        AppSelectionItem(value: .system, title: 'System', description: 'Matches your device'),
        AppSelectionItem(value: .light, title: 'Light', description: 'Bright and clear'),
        AppSelectionItem(value: .dark, title: 'Dark', description: 'Easy on the eyes'),
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
      padding: const .symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: context.appTheme.descriptionColor),
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
      child = ColoredBox(color: context.appTheme.selectedBackgroundColor, child: child);
    }

    return child;
  }
}

class NotificationsSettingsEntry extends StatelessWidget {
  const NotificationsSettingsEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<NotificationsSettingsCubit>();

    return switch (cubit.state) {
      Initial() || Loading() => const DataLoading(expand: false),
      Error() => const SizedBox.shrink(),
      Data(:var value) => _settingsData(cubit, value),
    };
  }

  Widget _settingsData(NotificationsSettingsCubit cubit, NotificationsSettings settings) {
    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        const ListSectionHeader(title: 'Notifications'),
        _rotationChangedEntry(cubit, settings),
        _championsAvailableEntry(cubit, settings),
      ],
    );
  }

  Widget _rotationChangedEntry(NotificationsSettingsCubit cubit, NotificationsSettings settings) {
    return ListEntry(
      title: 'Rotation changed',
      description: 'Receive a notification whenever the current free rotation changes.',
      trailing: Switch(
        value: settings.rotationChanged,
        onChanged: cubit.changeRotationChangedEnabled,
      ),
    );
  }

  Widget _championsAvailableEntry(
    NotificationsSettingsCubit cubit,
    NotificationsSettings settings,
  ) {
    return ListEntry(
      title: 'Champions available',
      description:
          'Receive a notification when champions that you observe become available in the rotation.',
      trailing: Switch(
        value: settings.championsAvailable,
        onChanged: cubit.changeChampionsAvailableEnabled,
      ),
    );
  }
}

class PredictionsEnabledEntry extends StatelessWidget {
  const PredictionsEnabledEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final predictionsEnabled = context.select(
      (LocalSettingsCubit cubit) => cubit.state.settings.predictionsEnabled,
    );
    final changePredictionsEnabled = context.read<LocalSettingsCubit>().changePredictionsEnabled;

    return ListEntry(
      title: 'Predictions',
      description: 'Display upcoming champion rotations based on patterns from previous rotations.',
      trailing: Switch(value: predictionsEnabled, onChanged: changePredictionsEnabled),
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
        padding: const .symmetric(horizontal: 20),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
