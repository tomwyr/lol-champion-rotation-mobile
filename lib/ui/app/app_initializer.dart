import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/application/app_store_cubit.dart';
import '../../core/application/local_settings/local_settings_cubit.dart';
import '../../core/application/startup/startup_cubit.dart';
import '../common/widgets/lifecycle.dart';
import 'app_brightness_style.dart';

class AppInitializer extends StatelessWidget {
  const AppInitializer({
    super.key,
    required this.builder,
  });

  final Widget Function(ThemeMode themeMode) builder;

  @override
  Widget build(BuildContext context) {
    return Lifecycle.builder(
      onInit: () => _initializeCubits(context),
      builder: (context) {
        final startupInitialized = context.select((StartupCubit cubit) => cubit.state.initialized);
        if (!startupInitialized) {
          return const SizedBox.shrink();
        }

        final settingsState = context.select(
          (LocalSettingsCubit cubit) => (
            initialized: cubit.state.initialized,
            themeMode: cubit.state.settings.themeMode,
          ),
        );
        if (!settingsState.initialized) {
          return const SizedBox.shrink();
        }
        return AppBrightnessStyle(
          themeMode: settingsState.themeMode,
          child: builder(settingsState.themeMode),
        );
      },
    );
  }

  void _initializeCubits(BuildContext context) async {
    final (startupCubit, appStoreCubit, localSettingsCubit) = (
      context.read<StartupCubit>(),
      context.read<AppStoreCubit>(),
      context.read<LocalSettingsCubit>(),
    );
    await startupCubit.initialize();
    appStoreCubit.checkForUpdate();
    localSettingsCubit.initialize();
  }
}
