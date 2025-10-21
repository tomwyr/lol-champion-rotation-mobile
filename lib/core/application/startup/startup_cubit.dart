import '../../../common/base_cubit.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/startup_service.dart';
import 'startup_state.dart';

class StartupCubit extends BaseCubit<StartupState> {
  StartupCubit({
    required this.startupService,
    required this.authService,
  }) : super(StartupState(initialized: false));

  final StartupService startupService;
  final AuthService authService;

  Future<void> initialize() async {
    if (state.initialized) return;
    await startupService.initialize(
      onFirstRun: authService.invalidate,
    );
    emit(StartupState(initialized: true));
  }
}
