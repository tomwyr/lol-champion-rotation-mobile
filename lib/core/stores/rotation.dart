import 'package:flutter/foundation.dart';

import '../../data/api_client.dart';
import '../model/rotation.dart';
import '../state.dart';

class RotationStore {
  RotationStore({required this.apiClient});

  final AppApiClient apiClient;

  final ValueNotifier<CurrentRotationState> state = ValueNotifier(Initial());

  Future<void> loadCurrentRotation() async {
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

  Future<void> _fetchCurrentRotation() async {
    try {
      final currentRotation = await apiClient.currentRotation();
      state.value = Data(currentRotation);
    } catch (_) {
      state.value = Error();
    }
  }
}

typedef CurrentRotationState = DataState<ChampionRotation>;
