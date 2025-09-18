import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/auth_service.dart';
import '../../data/services/startup_service.dart';

class StartupCubit extends Cubit {
  StartupCubit({
    required this.initService,
    required this.authService,
  }) : super(null);

  final StartupService initService;
  final AuthService authService;

  Future<void> initialize() async {
    await initService.initialize(
      onFirstRun: authService.invalidate,
    );
  }
}
