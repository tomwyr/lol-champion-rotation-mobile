import 'dart:async';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/foundation.dart';

import '../../data/api_client.dart';
import '../events.dart';
import '../model/champion.dart';
import '../state.dart';

part 'champion_details.g.dart';

class ChampionDetailsStore {
  ChampionDetailsStore({
    required this.appEvents,
    required this.apiClient,
  });

  final AppEvents appEvents;
  final AppApiClient apiClient;

  final ValueNotifier<ChampionDetailsState> state = ValueNotifier(Initial());
  final StreamController<ChampionDetailsEvent> events = StreamController.broadcast();

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
      state.value = Data(ChampionDetailsData(champion: championDetails));
    } catch (_) {
      state.value = Error();
    }
  }

  void toggleObserve() async {
    final ChampionDetailsData currentData;
    if (state.value case Data(:var value) when !value.togglingObserve) {
      currentData = value;
    } else {
      return;
    }

    state.value = Data(currentData.copyWith(togglingObserve: true));
    try {
      final input = ObserveChampionInput(observing: !currentData.champion.observing);
      await apiClient.observeChampion(_championId, input);
      final updatedData = currentData.copyWith(
        champion: currentData.champion.copyWith(observing: input.observing),
      );
      state.value = Data(updatedData);
      appEvents.championBookmarksChanged.notify();
    } catch (_) {
      events.add(ChampionDetailsEvent.observingFailed);
      state.value = Data(currentData);
    }
  }
}

@CopyWith()
class ChampionDetailsData {
  ChampionDetailsData({
    required this.champion,
    this.togglingObserve = false,
  });

  final ChampionDetails champion;
  final bool togglingObserve;
}

enum ChampionDetailsEvent {
  observingFailed,
}

typedef ChampionDetailsState = DataState<ChampionDetailsData>;
