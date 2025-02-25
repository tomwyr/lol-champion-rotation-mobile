import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/api_client.dart';
import '../model/rotation.dart';
import '../state.dart';

class RotationStore {
  RotationStore({required this.apiClient});

  final AppApiClient apiClient;

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
      final newData = currentData?.replacingCurrent(currentRotation) ??
          RotationData(currentRotation: currentRotation);
      state.value = Data(newData);
    } catch (_) {
      state.value = Error();
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

class RotationData {
  RotationData({
    required this.currentRotation,
    this.nextRotations = const [],
  });

  final CurrentChampionRotation currentRotation;
  final List<ChampionRotation> nextRotations;

  bool get hasNextRotation => nextRotationToken != null;

  String? get nextRotationToken {
    return nextRotations.lastOrNull?.nextRotationToken ?? currentRotation.nextRotationToken;
  }

  RotationData replacingCurrent(CurrentChampionRotation currentRotation) {
    return RotationData(
      currentRotation: currentRotation,
      nextRotations: nextRotations,
    );
  }

  RotationData appendingNext(ChampionRotation nextRotation) {
    return RotationData(
      currentRotation: currentRotation,
      nextRotations: [...nextRotations, nextRotation],
    );
  }
}

enum RotationEvent {
  loadingMoreDataError,
}
