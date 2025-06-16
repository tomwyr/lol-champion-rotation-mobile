import 'dart:async';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/foundation.dart';

import '../../common/utils/cancelable.dart';
import '../../data/api_client.dart';
import '../../data/services/local_settings_service.dart';
import '../../ui/common/utils/extensions.dart';
import '../events.dart';
import '../model/rotation.dart';
import '../state.dart';

part 'rotation.g.dart';

class RotationStore {
  RotationStore({
    required this.appEvents,
    required this.apiClient,
    required this.appSettings,
  }) {
    appEvents.predictionsEnabledChanged.addListener(_syncRotationPrediction);
  }

  final AppEvents appEvents;
  final AppApiClient apiClient;
  final LocalSettingsService appSettings;

  final ValueNotifier<RotationState> state = ValueNotifier(Initial());
  final StreamController<RotationEvent> events = StreamController.broadcast();

  final _activePredictionSync = CancelableTask();

  void loadRotationsOverview() async {
    if (state.value case Loading()) {
      return;
    }

    state.value = Loading();

    await _fetchRotationsOverview();
  }

  Future<void> refreshRotationsOverview() async {
    if (state.value case Loading()) {
      return;
    }

    await _fetchRotationsOverview();
  }

  Future<void> loadNextRotation() async {
    final RotationData currentData;
    if (state.value case Data(:var value) when value.hasNextRotation) {
      currentData = value;
    } else {
      return;
    }

    state.value = Data(currentData, loadingMore: true);

    await _fetchNextRotation(currentData);
  }

  Future<void> _fetchRotationsOverview() async {
    RotationData? currentData;
    if (state.value case Data(:var value)) {
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
      state.value = Data(newData);
    } catch (_) {
      state.value = Error();
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
      state.value = Data(currentData.appendingNext(nextRotation));
    } catch (_) {
      state.value = Data(currentData);
      events.add(RotationEvent.loadingMoreDataError);
    }
  }

  void _syncRotationPrediction() async {
    final task = _activePredictionSync.startNew();
    final currentData = await state.untilFirst<Data<RotationData>>();
    final predictedRotation = await _loadRotationPrediction();
    if (task.canceled) return;
    state.value = Data(currentData.value.copyWith(predictedRotation: predictedRotation));
  }
}

typedef RotationState = DataState<RotationData>;

@CopyWith()
class RotationData {
  RotationData({
    required this.rotationsOverview,
    this.nextRotations = const [],
    this.predictedRotation,
  });

  final ChampionRotationsOverview rotationsOverview;
  final List<ChampionRotation> nextRotations;
  final ChampionRotationPrediction? predictedRotation;

  bool get hasNextRotation => nextRotationToken != null;

  String? get nextRotationToken {
    return nextRotations.lastOrNull?.nextRotationToken ?? rotationsOverview.nextRotationToken;
  }

  RotationData appendingNext(ChampionRotation nextRotation) {
    return copyWith(nextRotations: [...nextRotations, nextRotation]);
  }
}

enum RotationEvent {
  loadingMoreDataError,
  loadingPredictionError,
}
