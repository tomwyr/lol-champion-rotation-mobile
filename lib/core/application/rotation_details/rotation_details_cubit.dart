import 'dart:async';

import '../../../common/base_cubit.dart';
import '../../../data/repositories/rotation_details_repository.dart';
import '../../events.dart';
import '../../state.dart';
import 'rotation_details_state.dart';

class RotationDetailsCubit extends BaseCubit<RotationDetailsState> {
  RotationDetailsCubit({required this.appEvents, required this.repository}) : super(Initial());

  final AppEvents appEvents;
  final RotationDetailsRepository repository;

  final StreamController<RotationDetailsEvent> events = .broadcast();

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
    final cacheLoaded = await _loadCachedRotation();
    final freshLoaded = await _refreshRotation();
    if (cacheLoaded && !freshLoaded) {
      events.add(.refreshFailed);
    } else if (!cacheLoaded && !freshLoaded) {
      emit(Error());
    }
  }

  Future<bool> _loadCachedRotation() async {
    try {
      final cachedData = await repository.loadCachedRotation(_rotationId);
      if (cachedData != null) {
        emit(Data(RotationDetailsData(rotation: cachedData)));
        return true;
      }
    } catch (_) {
      // Ignore
    }
    return false;
  }

  Future<bool> _refreshRotation() async {
    void emitRefreshing(bool value) {
      if (state case Data(value: var currentData)) {
        emit(Data(currentData, refreshing: value));
      }
    }

    emitRefreshing(true);
    try {
      final rotation = await repository.refreshRotation(_rotationId);
      emit(Data(RotationDetailsData(rotation: rotation)));
      return true;
    } catch (_) {
      emitRefreshing(false);
    }
    return false;
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
      await repository.observeRotation(_rotationId, newObserving);
      final updatedData = currentData.withObserving(newObserving);
      emit(Data(updatedData));
      appEvents.observedRotationsChanged.notify();
      events.add(newObserving ? .rotationObserved : .rotationUnobserved);
    } catch (_) {
      events.add(.observingFailed);
      emit(Data(currentData));
    }
  }
}
