import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../../data/api_client.dart';
import '../../events.dart';
import '../../model/rotation.dart';
import '../../state.dart';
import 'rotation_details_state.dart';

part 'rotation_details_store.g.dart';

class RotationDetailsStore extends _RotationDetailsStore with _$RotationDetailsStore {
  RotationDetailsStore({
    required super.appEvents,
    required super.apiClient,
  });
}

abstract class _RotationDetailsStore with Store {
  _RotationDetailsStore({
    required this.appEvents,
    required this.apiClient,
  });

  final AppEvents appEvents;
  final AppApiClient apiClient;

  final StreamController<RotationDetailsEvent> events = StreamController.broadcast();

  @readonly
  RotationDetailsState _state = Initial();

  late String _rotationId;

  @action
  void initialize(String rotationId) {
    _rotationId = rotationId;
    _loadRotation();
  }

  @action
  Future<void> _loadRotation() async {
    if (_state case Loading()) {
      return;
    }

    _state = Loading();

    try {
      final rotation = await apiClient.rotation(rotationId: _rotationId);
      _state = Data(RotationDetailsData(rotation: rotation));
    } catch (_) {
      _state = Error();
    }
  }

  @readonly
  Future<void> toggleObserved() async {
    final RotationDetailsData currentData;
    if (_state case Data(:var value) when !value.togglingObserved) {
      currentData = value;
    } else {
      return;
    }

    _state = Data(currentData.copyWith(togglingObserved: true));
    try {
      final newObserving = !currentData.rotation.observing;
      final input = ObserveRotationInput(observing: newObserving);
      await apiClient.observeRotation(_rotationId, input);
      final updatedData = currentData.copyWith(
        rotation: currentData.rotation.copyWith(observing: newObserving),
      );
      _state = Data(updatedData);
      appEvents.observedRotationsChanged.notify();
      events.add(
        newObserving
            ? RotationDetailsEvent.rotationObserved
            : RotationDetailsEvent.rotationUnobserved,
      );
    } catch (_) {
      events.add(RotationDetailsEvent.observingFailed);
      _state = Data(currentData);
    }
  }
}
