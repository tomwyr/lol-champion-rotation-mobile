import '../../../common/base_cubit.dart';
import '../../../data/api_client.dart';
import '../../../data/services/error_service.dart';
import '../../events.dart';
import '../../state.dart';
import 'observed_rotations_state.dart';

class ObservedRotationsCubit extends BaseCubit<ObservedRotationsState> {
  ObservedRotationsCubit({
    required this.appEvents,
    required this.apiClient,
    required this.errorService,
  }) : super(Initial()) {
    appEvents.observedRotationsChanged.addListener(loadRotations);
  }

  final AppApiClient apiClient;
  final AppEvents appEvents;
  final ErrorService errorService;

  Future<void> loadRotations() async {
    if (state case Loading()) {
      return;
    }

    emit(Loading());
    try {
      final data = await apiClient.observedRotations();
      emit(Data(data.rotations));
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
      emit(Error());
    }
  }

  @override
  Future<void> close() {
    appEvents.observedRotationsChanged.removeListener(loadRotations);
    return super.close();
  }
}
