import 'package:flutter/foundation.dart';

import '../../data/api_client.dart';
import '../events.dart';
import '../model/champion.dart';
import '../state.dart';

class ChampionBookmarksStore {
  ChampionBookmarksStore({
    required this.appEvents,
    required this.apiClient,
  }) {
    appEvents.championBookmarksChanged.addListener(loadBookmarks);
  }

  final AppApiClient apiClient;
  final AppEvents appEvents;

  final ValueNotifier<ChampionBookmarksState> state = ValueNotifier(Initial());

  Future<void> loadBookmarks() async {
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

typedef ChampionBookmarksState = DataState<List<ObservedChampion>>;
