import 'package:flutter/foundation.dart';

import '../../data/api_client.dart';
import '../model/rotation.dart';
import '../state.dart';

class RotationDetailsStore {
  RotationDetailsStore({required this.apiClient});

  final AppApiClient apiClient;

  final ValueNotifier<RotationDetailsState> state = ValueNotifier(Initial());

  late String _rotationId;

  void initialize(String rotationId) {
    _rotationId = rotationId;
    _loadRotation();
  }

  void _loadRotation() async {
    if (state.value case Loading()) {
      return;
    }

    state.value = Loading();

    try {
      final rotation = await apiClient.rotation(rotationId: _rotationId);
      state.value = Data(rotation);
    } catch (_) {
      state.value = Error();
    }
  }
}

typedef RotationDetailsState = DataState<ChampionRotation>;
