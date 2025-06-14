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

  void toggleObserved() async {
    final ChampionDetailsData currentData;
    if (state.value case Data(:var value) when !value.togglingObserved) {
      currentData = value;
    } else {
      return;
    }

    state.value = Data(currentData.copyWith(togglingObserved: true));
    try {
      final newObserving = !currentData.champion.observing;
      final input = ObserveChampionInput(observing: newObserving);
      await apiClient.observeChampion(_championId, input);
      final updatedData = currentData.copyWith(
        champion: currentData.champion.copyWith(observing: newObserving),
      );
      state.value = Data(updatedData);
      appEvents.observedChampionsChanged.notify();
      events.add(
        newObserving
            ? ChampionDetailsEvent.championObserved
            : ChampionDetailsEvent.championUnobserved,
      );
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
    this.togglingObserved = false,
  });

  final ChampionDetails champion;
  final bool togglingObserved;
}

enum ChampionDetailsEvent {
  observingFailed,
  championObserved,
  championUnobserved,
}

typedef ChampionDetailsState = DataState<ChampionDetailsData>;
