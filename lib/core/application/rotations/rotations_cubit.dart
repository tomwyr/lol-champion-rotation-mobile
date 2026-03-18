import 'dart:async';

import '../../../common/base_cubit.dart';
import '../../../common/utils/cancelable.dart';
import '../../../data/repositories/rotations_repository.dart';
import '../../../ui/common/utils/extensions.dart';
import '../../events.dart';
import '../../model/rotations_data.dart';
import '../../state.dart';
import 'rotations_state.dart';

class RotationsCubit extends BaseCubit<RotationsState> {
  RotationsCubit({required this.appEvents, required this.repository}) : super(Initial()) {
    appEvents.predictionsEnabledChanged.addListener(_syncRotationPrediction);
    appEvents.currentRotationChanged.addListener(refreshRotationsOverview);
  }

  final AppEvents appEvents;
  final RotationsRepository repository;

  final StreamController<RotationsEvent> events = .broadcast();

  final _activePredictionSync = CancelableTask();

  Future<void> loadRotations() async {
    if (state case Loading()) {
      return;
    }

    emit(Loading());
    final cacheLoaded = await _loadCachedRotations();
    final freshLoaded = await _refreshRotations();
    if (cacheLoaded && !freshLoaded) {
      events.add(.refreshFailed);
    } else if (!cacheLoaded && !freshLoaded) {
      emit(Error());
    }
  }

  Future<void> refreshRotationsOverview() async {
    if (state case Loading() || Data(refreshing: true)) {
      return;
    }

    final RotationsData currentData;
    if (state case Data(:var value)) {
      currentData = value;
    } else {
      return;
    }

    try {
      final (updatedData, rotationPredictionError) = await repository.refreshRotationsOverview(
        currentData,
      );
      if (rotationPredictionError) {
        events.add(.loadingPredictionError);
      }
      emit(Data(updatedData));
    } catch (_) {
      // Ignore
    }
  }

  Future<void> loadNextRotation() async {
    final RotationsData currentData;
    if (state case Data(:var value, refreshing: false) when value.hasNextRotation) {
      currentData = value;
    } else {
      return;
    }

    emit(Data(currentData, loadingMore: true));
    try {
      final updatedData = await repository.loadNextRotation(currentData);
      emit(Data(updatedData));
    } catch (_) {
      emit(Data(currentData));
      events.add(.loadingMoreDataError);
    }
  }

  Future<bool> _loadCachedRotations() async {
    try {
      final cachedData = await repository.loadCachedRotations();
      if (cachedData != null) {
        emit(Data(cachedData));
        return true;
      }
    } catch (_) {
      // Ignore
    }
    return false;
  }

  Future<bool> _refreshRotations() async {
    void emitRefreshing(bool value) {
      if (state case Data(value: var currentData)) {
        emit(Data(currentData, refreshing: value));
      }
    }

    emitRefreshing(true);
    try {
      final (rotationsData, rotationPredictionError) = await repository.refreshRotations();
      if (rotationPredictionError) {
        events.add(.loadingPredictionError);
      }
      emit(Data(rotationsData));
      return true;
    } catch (_) {
      emitRefreshing(false);
    }
    return false;
  }

  void _syncRotationPrediction() async {
    try {
      final task = _activePredictionSync.startNew();
      final currentData = await untilState<Data<RotationsData>>();
      final rotationPrediction = await repository.loadRotationPrediction();
      if (task.canceled) return;
      emit(Data(currentData.value.copyWith(rotationPrediction: rotationPrediction)));
    } catch (_) {
      events.add(.loadingPredictionError);
    }
  }

  @override
  Future<void> close() {
    appEvents.predictionsEnabledChanged.removeListener(_syncRotationPrediction);
    appEvents.currentRotationChanged.removeListener(refreshRotationsOverview);
    return super.close();
  }
}
