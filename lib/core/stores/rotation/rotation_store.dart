import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../../common/utils/cancelable.dart';
import '../../../data/api_client.dart';
import '../../../data/services/local_settings_service.dart';
import '../../../ui/common/utils/reactions.dart';
import '../../events.dart';
import '../../model/rotation.dart';
import '../../state.dart';
import 'rotation_state.dart';

part 'rotation_store.g.dart';

class RotationStore extends _RotationStore with _$RotationStore {
  RotationStore({
    required super.appEvents,
    required super.apiClient,
    required super.appSettings,
  });
}

abstract class _RotationStore with Store {
  _RotationStore({
    required this.appEvents,
    required this.apiClient,
    required this.appSettings,
  }) {
    appEvents.predictionsEnabledChanged.addListener(_syncRotationPrediction);
  }

  final AppEvents appEvents;
  final AppApiClient apiClient;
  final LocalSettingsService appSettings;

  final StreamController<RotationEvent> events = StreamController.broadcast();

  @readonly
  RotationState _state = Initial();

  final _activePredictionSync = CancelableTask();

  @action
  Future<void> loadRotationsOverview() async {
    if (_state case Loading()) {
      return;
    }

    _state = Loading();

    await _fetchRotationsOverview();
  }

  @action
  Future<void> refreshRotationsOverview() async {
    if (_state case Loading()) {
      return;
    }

    await _fetchRotationsOverview();
  }

  @action
  Future<void> loadNextRotation() async {
    final RotationData currentData;
    if (_state case Data(:var value) when value.hasNextRotation) {
      currentData = value;
    } else {
      return;
    }

    _state = Data(currentData, loadingMore: true);

    await _fetchNextRotation(currentData);
  }

  Future<void> _fetchRotationsOverview() async {
    RotationData? currentData;
    if (_state case Data(:var value)) {
      currentData = value;
    }

    try {
      final rotationsOverview = await apiClient.rotationsOverview();
      final predictedRotation = await _loadRotationPrediction();

      final newData = switch (currentData) {
        RotationData() => currentData.copyWith(
            rotationsOverview: rotationsOverview,
            predictedRotation: predictedRotation,
          ),
        null => RotationData(
            rotationsOverview: rotationsOverview,
            predictedRotation: predictedRotation,
          ),
      };
      _state = Data(newData);
    } catch (_) {
      _state = Error();
    }
  }

  Future<ChampionRotationPrediction?> _loadRotationPrediction() async {
    try {
      final predictionsEnabled = await appSettings.getPredictionsEnabled();
      if (!predictionsEnabled) {
        return null;
      }
      return await apiClient.predictRotation();
    } catch (_) {
      events.add(RotationEvent.loadingPredictionError);
      return null;
    }
  }

  Future<void> _fetchNextRotation(RotationData currentData) async {
    final token = currentData.nextRotationToken!;

    try {
      final nextRotation = await apiClient.nextRotation(token: token);
      _state = Data(currentData.appendingNext(nextRotation));
    } catch (_) {
      _state = Data(currentData);
      events.add(RotationEvent.loadingMoreDataError);
    }
  }

  void _syncRotationPrediction() async {
    final task = _activePredictionSync.startNew();
    final currentData = await until<Data<RotationData>>(() => _state);
    final predictedRotation = await _loadRotationPrediction();
    if (task.canceled) return;
    _state = Data(currentData.value.copyWith(predictedRotation: predictedRotation));
  }
}
