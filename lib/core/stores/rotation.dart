import 'dart:async';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/foundation.dart';

import '../../data/api_client.dart';
import '../../data/app_settings_service.dart';
import '../model/rotation.dart';
import '../state.dart';

part 'rotation.g.dart';

class RotationStore {
  RotationStore({
    required this.apiClient,
    required this.appSettings,
  });

  final AppApiClient apiClient;
  final AppSettingsService appSettings;

  final ValueNotifier<RotationState> state = ValueNotifier(Initial());
  final StreamController<RotationEvent> events = StreamController.broadcast();

  void loadCurrentRotation() async {
    if (state.value case Loading()) {
      return;
    }

    state.value = Loading();

    await _fetchCurrentRotation();
  }

  Future<void> refreshCurrentRotation() async {
    if (state.value case Loading()) {
      return;
    }

    await _fetchCurrentRotation();
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

  Future<void> _fetchCurrentRotation() async {
    RotationData? currentData;
    if (state.value case Data(:var value)) {
      currentData = value;
    }

    try {
      final currentRotation = await apiClient.currentRotation();
      final prediction = await _loadRotationPrediction();

      final newData = switch (currentData) {
        RotationData() => currentData.copyWith(
            currentRotation: currentRotation,
            prediction: prediction,
          ),
        null => RotationData(
            currentRotation: currentRotation,
            predictedRotation: prediction,
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
}

typedef RotationState = DataState<RotationData>;

@CopyWith()
class RotationData {
  RotationData({
    required this.currentRotation,
    this.nextRotations = const [],
    this.predictedRotation,
  });

  final CurrentChampionRotation currentRotation;
  final List<ChampionRotation> nextRotations;
  final ChampionRotationPrediction? predictedRotation;

  bool get hasNextRotation => nextRotationToken != null;

  String? get nextRotationToken {
    return nextRotations.lastOrNull?.nextRotationToken ?? currentRotation.nextRotationToken;
  }

  RotationData appendingNext(ChampionRotation nextRotation) {
    return copyWith(nextRotations: [...nextRotations, nextRotation]);
  }
}

enum RotationEvent {
  loadingMoreDataError,
  loadingPredictionError,
}
