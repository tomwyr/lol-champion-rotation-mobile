import 'dart:async';

import '../../../common/base_cubit.dart';
import '../../../data/api_client.dart';
import '../../events.dart';
import '../../model/rotation.dart';
import '../../state.dart';
import 'rotation_details_state.dart';

class RotationDetailsCubit extends BaseCubit<RotationDetailsState> {
  RotationDetailsCubit({
    required this.appEvents,
    required this.apiClient,
  }) : super(Initial());

  final AppEvents appEvents;
  final AppApiClient apiClient;

  final StreamController<RotationDetailsEvent> events = StreamController.broadcast();

  late String _rotationId;

  void initialize(String rotationId) {
    _rotationId = rotationId;
    _loadRotation();
  }

  Future<void> _loadRotation() async {
    if (state case Loading()) {
      return;
    }

    emit(Loading());

    try {
      final rotation = await apiClient.rotation(rotationId: _rotationId);
      emit(Data(RotationDetailsData(rotation: rotation)));
    } catch (_) {
      emit(Error());
    }
  }

  Future<void> toggleObserved() async {
    final RotationDetailsData currentData;
    if (state case Data(:var value) when !value.togglingObserved) {
      currentData = value;
    } else {
      return;
    }

    emit(Data(currentData.copyWith(togglingObserved: true)));
    try {
      final newObserving = !currentData.rotation.observing;
      final input = ObserveRotationInput(observing: newObserving);
      await apiClient.observeRotation(_rotationId, input);
      final updatedData = currentData.copyWith(
        rotation: currentData.rotation.copyWith(observing: newObserving),
      );
      emit(Data(updatedData));
      appEvents.observedRotationsChanged.notify();
      events.add(
        newObserving
            ? RotationDetailsEvent.rotationObserved
            : RotationDetailsEvent.rotationUnobserved,
      );
    } catch (_) {
      events.add(RotationDetailsEvent.observingFailed);
      emit(Data(currentData));
    }
  }
}
