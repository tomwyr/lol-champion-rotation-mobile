import 'package:flutter/foundation.dart';

import '../../data/api_client.dart';
import '../events.dart';
import '../model/rotation.dart';
import '../state.dart';

class ObservedRotationsStore {
  ObservedRotationsStore({
    required this.appEvents,
    required this.apiClient,
  }) {
    appEvents.observedRotationsChanged.addListener(loadRotations);
  }

  final AppApiClient apiClient;
  final AppEvents appEvents;

  final ValueNotifier<ObservedRotationsState> state = ValueNotifier(Initial());

  Future<void> loadRotations() async {
    if (state.value case Loading()) {
      return;
    }

    state.value = Loading();
    try {
      final data = await apiClient.observedRotations();
      state.value = Data(data.rotations);
    } catch (_) {
      state.value = Error();
    }
  }
}

typedef ObservedRotationsState = DataState<List<ObservedRotation>>;
