import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/application/app_store_cubit.dart';
import '../../core/application/local_settings/local_settings_cubit.dart';
import '../../core/application/notifications/notifications_cubit.dart';
import '../../core/application/notifications_settings/notifications_settings_cubit.dart';
import '../../core/application/startup/startup_cubit.dart';
import '../../dependencies/locate.dart';

class AppCubitsProvider extends StatelessWidget {
  const AppCubitsProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locateNew<AppStoreCubit>()),
        BlocProvider(create: (_) => locateNew<LocalSettingsCubit>()),
        BlocProvider(create: (_) => locateNew<NotificationsCubit>()),
        BlocProvider(create: (_) => locateNew<NotificationsSettingsCubit>()),
        BlocProvider(create: (_) => locateNew<StartupCubit>()),
      ],
      child: child,
    );
  }
}
