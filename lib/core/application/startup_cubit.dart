import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/auth_service.dart';
import '../../data/services/startup_service.dart';

class StartupCubit extends Cubit {
  StartupCubit({
    required this.startupService,
    required this.authService,
  }) : super(null);

  final StartupService startupService;
  final AuthService authService;

  Future<void> initialize() async {
    await startupService.initialize(
      onFirstRun: authService.invalidate,
    );
  }
}
