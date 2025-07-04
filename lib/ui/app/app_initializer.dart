import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/application/app_store_cubit.dart';
import '../../core/application/local_settings/local_settings_cubit.dart';
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
      onInit: () {
        context.read<AppStoreCubit>().checkForUpdate();
        context.read<LocalSettingsCubit>().initialize();
      },
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
}
