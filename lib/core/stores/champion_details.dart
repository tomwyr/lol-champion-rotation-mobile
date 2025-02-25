import 'package:flutter/foundation.dart';

import '../../data/api_client.dart';
import '../model/champion.dart';
import '../state.dart';

class ChampionDetailsStore {
  ChampionDetailsStore({required this.apiClient});

  final AppApiClient apiClient;

  final ValueNotifier<ChampionDetailsState> state = ValueNotifier(Initial());

  late String _championId;

  void initialize(String championId) {
    _championId = championId;
    _loadChampion();
  }

  void _loadChampion() async {
    if (state.value case Loading()) {
      return;
    }

    state.value = Loading();

    try {
      final championDetails = await apiClient.championDetails(championId: _championId);
      state.value = Data(championDetails);
    } catch (_) {
      state.value = Error();
    }
  }
}

typedef ChampionDetailsState = DataState<ChampionDetails>;
