import 'dart:async';

import '../../../common/base_cubit.dart';
import '../../../common/utils/cancelable.dart';
import '../../../data/api_client.dart';
import '../../../data/services/local_settings_service.dart';
import '../../../ui/common/utils/extensions.dart';
import '../../events.dart';
import '../../model/rotation.dart';
import '../../state.dart';
import 'rotation_state.dart';

class RotationCubit extends BaseCubit<RotationState> {
  RotationCubit({required this.appEvents, required this.apiClient, required this.appSettings})
    : super(Initial()) {
    appEvents.predictionsEnabledChanged.addListener(_syncRotationPrediction);
  }

  final AppEvents appEvents;
  final AppApiClient apiClient;
  final LocalSettingsService appSettings;

  final StreamController<RotationEvent> events = .broadcast();

  final _activePredictionSync = CancelableTask();

  Future<void> loadRotationsOverview() async {
    if (state case Loading()) {
      return;
    }

    emit(Loading());

    await _fetchRotationsOverview();
  }

  Future<void> refreshRotationsOverview() async {
    if (state case Loading()) {
      return;
    }

    await _fetchRotationsOverview();
  }

  Future<void> loadNextRotation() async {
    final RotationData currentData;
    if (state case Data(:var value) when value.hasNextRotation) {
      currentData = value;
    } else {
      return;
    }

    emit(Data(currentData, loadingMore: true));

    await _fetchNextRotation(currentData);
  }

  Future<void> _fetchRotationsOverview() async {
    RotationData? currentData;
    if (state case Data(:var value)) {
      currentData = value;
    }

    try {
      final rotationsOverview = await apiClient.rotationsOverview();
      final (formerCurrentRotation, predictedRotation) = await (
        _loadFormerCurrentRotation(currentData, rotationsOverview),
        _loadRotationPrediction(),
      ).wait;

      final nextRotations = [?formerCurrentRotation, ...?currentData?.nextRotations];

      final newData = switch (currentData) {
        RotationData() => currentData.copyWith(
          rotationsOverview: rotationsOverview,
          predictedRotation: predictedRotation,
          nextRotations: nextRotations,
        ),
        null => RotationData(
          rotationsOverview: rotationsOverview,
          predictedRotation: predictedRotation,
          nextRotations: nextRotations,
        ),
      };
      emit(Data(newData));
    } catch (_) {
      emit(Error());
    }
  }

  /// Fetches the next rotation to prevent losing the previously current one
  /// when refreshed data contains a newer rotation.
  Future<ChampionRotation?> _loadFormerCurrentRotation(
    RotationData? currentData,
    ChampionRotationsOverview refreshedOverview,
  ) async {
    // Skip for the initial data fetch.
    if (currentData == null) return null;

    final rotationChanged = currentData.rotationsOverview.id != refreshedOverview.id;
    final token = refreshedOverview.nextRotationToken;

    if (!rotationChanged || token == null) {
      return null;
    }

    return await apiClient.nextRotation(token: token);
  }

  Future<ChampionRotationPrediction?> _loadRotationPrediction() async {
    try {
      final predictionsEnabled = await appSettings.getPredictionsEnabled();
      if (!predictionsEnabled) {
        return null;
      }
      return await apiClient.predictRotation();
    } catch (_) {
      events.add(.loadingPredictionError);
      return null;
    }
  }

  Future<void> _fetchNextRotation(RotationData currentData) async {
    final token = currentData.nextRotationToken!;

    try {
      final nextRotation = await apiClient.nextRotation(token: token);
      emit(Data(currentData.appendingNext(nextRotation)));
    } catch (_) {
      emit(Data(currentData));
      events.add(.loadingMoreDataError);
    }
  }

  void _syncRotationPrediction() async {
    final task = _activePredictionSync.startNew();
    final currentData = await untilState<Data<RotationData>>();
    final predictedRotation = await _loadRotationPrediction();
    if (task.canceled) return;
    emit(Data(currentData.value.copyWith(predictedRotation: predictedRotation)));
  }

  @override
  Future<void> close() {
    appEvents.predictionsEnabledChanged.removeListener(_syncRotationPrediction);
    return super.close();
  }
}
