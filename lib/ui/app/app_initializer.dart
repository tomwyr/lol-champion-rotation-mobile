import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/application/app_store_cubit.dart';
import '../../core/application/local_settings/local_settings_cubit.dart';
import '../../core/application/startup_cubit.dart';
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
        final (:initialized, :themeMode) = context.select(
          (LocalSettingsCubit cubit) => (
            initialized: cubit.state.initialized,
            themeMode: cubit.state.settings.themeMode,
          ),
        );

        if (!initialized) {
          return const SizedBox.shrink();
        }
        return AppBrightnessStyle(
          themeMode: themeMode,
          child: builder(themeMode),
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
