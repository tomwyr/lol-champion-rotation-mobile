import 'package:flutter/foundation.dart';

import '../../data/api_client.dart';
import '../events.dart';
import '../model/champion.dart';
import '../state.dart';

class ObservedChampionsStore {
  ObservedChampionsStore({
    required this.appEvents,
    required this.apiClient,
  }) {
    appEvents.observedChampionsChanged.addListener(loadChampions);
  }

  final AppApiClient apiClient;
  final AppEvents appEvents;

  final ValueNotifier<ObservedChampionsState> state = ValueNotifier(Initial());

  Future<void> loadChampions() async {
    if (state.value case Loading()) {
      return;
    }

    state.value = Loading();
    try {
      final data = await apiClient.observedChampions();
      state.value = Data(data.champions);
    } catch (_) {
      state.value = Error();
    }
  }
}

typedef ObservedChampionsState = DataState<List<ObservedChampion>>;
