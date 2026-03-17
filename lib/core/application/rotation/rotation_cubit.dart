import 'dart:async';

import '../../../common/base_cubit.dart';
import '../../../common/utils/cancelable.dart';
import '../../../data/api_client.dart';
import '../../../data/cache/data_cache.dart';
import '../../../data/services/error_service.dart';
import '../../../data/services/local_settings_service.dart';
import '../../../ui/common/utils/extensions.dart';
import '../../events.dart';
import '../../model/rotation.dart';
import '../../model/rotations_data.dart';
import '../../state.dart';
import 'rotation_state.dart';

class RotationCubit extends BaseCubit<RotationState> {
  RotationCubit({
    required this.appEvents,
    required this.apiClient,
    required this.appSettings,
    required this.dataCache,
    required this.errorService,
  }) : super(Initial()) {
    appEvents.predictionsEnabledChanged.addListener(_syncRotationPrediction);
    appEvents.currentRotationChanged.addListener(refreshRotationsOverview);
  }

  final AppEvents appEvents;
  final AppApiClient apiClient;
  final LocalSettingsService appSettings;
  final DataCache dataCache;
  final ErrorService errorService;

  final StreamController<RotationEvent> events = .broadcast();

  final _activePredictionSync = CancelableTask();

  Future<void> loadRotations() async {
    if (state case Loading()) {
      return;
    }

    emit(Loading());
    final cacheLoaded = await _loadCachedRotations();
    final freshLoaded = await _fetchFreshRotations();
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
      final rotationsOverview = await apiClient.rotationsOverview();
      final (formerCurrentRotation, rotationPrediction) = await (
        _loadFormerCurrentRotation(currentData, rotationsOverview),
        _loadRotationPrediction(),
      ).wait;
      final nextRotations = [?formerCurrentRotation, ...currentData.nextRotations];
      final newData = currentData.copyWith(
        rotationsOverview: rotationsOverview,
        rotationPrediction: rotationPrediction,
        nextRotations: nextRotations,
      );
      unawaited(_cacheRotationList(newData));
      emit(Data(newData));
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
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
      final token = currentData.nextRotationToken!;
      final nextRotation = await apiClient.nextRotation(token: token);
      final newData = currentData.appendingNext(nextRotation);
      unawaited(_cacheRotationList(newData));
      emit(Data(newData));
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
      emit(Data(currentData));
      events.add(.loadingMoreDataError);
    }
  }

  Future<bool> _loadCachedRotations() async {
    var success = false;
    try {
      final cachedData = await dataCache.loadRotationsData();
      if (cachedData != null) {
        final rotationsData = RotationsData(
          rotationsOverview: cachedData.rotationsOverview,
          nextRotations: cachedData.nextRotations,
          rotationPrediction: null,
        );
        emit(Data(rotationsData));
        success = true;
      }
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
    }
    return success;
  }

  Future<bool> _fetchFreshRotations() async {
    void emitRefreshing(bool value) {
      if (state case Data(value: var currentData)) {
        emit(Data(currentData, refreshing: value));
      }
    }

    var success = false;
    emitRefreshing(true);
    try {
      final rotationsOverview = await apiClient.rotationsOverview();
      final rotationPrediction = await _loadRotationPrediction();
      final nextRotations = await _fetchNextRotations(
        initialToken: rotationsOverview.nextRotationToken,
        count: 3,
      );
      final rotationsData = RotationsData(
        rotationsOverview: rotationsOverview,
        rotationPrediction: rotationPrediction,
        nextRotations: nextRotations,
      );
      unawaited(_cacheRotationList(rotationsData));
      emit(Data(rotationsData));
      success = true;
    } catch (error, stackTrace) {
      emitRefreshing(false);
      errorService.reportSilent(error, stackTrace);
    }
    return success;
  }

  Future<List<ChampionRotation>> _fetchNextRotations({
    required String? initialToken,
    required int count,
  }) async {
    final nextRotations = <ChampionRotation>[];
    var token = initialToken;
    for (var i = 0; i < count; i++) {
      if (token == null) break;
      try {
        final rotation = await apiClient.nextRotation(token: token);
        nextRotations.add(rotation);
        token = rotation.nextRotationToken;
      } catch (error, stackTrace) {
        errorService.reportSilent(error, stackTrace);
        break;
      }
    }
    return nextRotations;
  }

  Future<void> _cacheRotationList(RotationsData rotationsData) async {
    try {
      await dataCache.saveRotationsData(rotationsData);
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
    }
  }

  /// Fetches the next rotation to prevent losing the previously current one
  /// when refreshed data contains a newer rotation.
  Future<ChampionRotation?> _loadFormerCurrentRotation(
    RotationsData? currentData,
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
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
      events.add(.loadingPredictionError);
      return null;
    }
  }

  void _syncRotationPrediction() async {
    final task = _activePredictionSync.startNew();
    final currentData = await untilState<Data<RotationsData>>();
    final rotationPrediction = await _loadRotationPrediction();
    if (task.canceled) return;
    emit(Data(currentData.value.copyWith(rotationPrediction: rotationPrediction)));
  }

  @override
  Future<void> close() {
    appEvents.predictionsEnabledChanged.removeListener(_syncRotationPrediction);
    appEvents.currentRotationChanged.removeListener(refreshRotationsOverview);
    return super.close();
  }
}
