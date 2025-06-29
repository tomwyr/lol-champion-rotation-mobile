import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../../data/api_client.dart';
import '../../events.dart';
import '../../model/champion.dart';
import '../../state.dart';
import 'champion_details_state.dart';

part 'champion_details_store.g.dart';

class ChampionDetailsStore extends _ChampionDetailsStore with _$ChampionDetailsStore {
  ChampionDetailsStore({
    required super.appEvents,
    required super.apiClient,
  });
}

abstract class _ChampionDetailsStore with Store {
  _ChampionDetailsStore({
    required this.appEvents,
    required this.apiClient,
  });

  final AppEvents appEvents;
  final AppApiClient apiClient;

  final StreamController<ChampionDetailsEvent> events = StreamController.broadcast();

  @readonly
  ChampionDetailsState _state = Initial();

  late String _championId;

  @action
  void initialize(String championId) {
    _championId = championId;
    _loadChampion();
  }

  @action
  Future<void> _loadChampion() async {
    if (_state case Loading()) {
      return;
    }

    _state = Loading();

    try {
      final championDetails = await apiClient.championDetails(championId: _championId);
      _state = Data(ChampionDetailsData(champion: championDetails));
    } catch (_) {
      _state = Error();
    }
  }

  @action
  Future<void> toggleObserved() async {
    final ChampionDetailsData currentData;
    if (_state case Data(:var value) when !value.togglingObserved) {
      currentData = value;
    } else {
      return;
    }

    _state = Data(currentData.copyWith(togglingObserved: true));
    try {
      final newObserving = !currentData.champion.observing;
      final input = ObserveChampionInput(observing: newObserving);
      await apiClient.observeChampion(_championId, input);
      final updatedData = currentData.copyWith(
        champion: currentData.champion.copyWith(observing: newObserving),
      );
      _state = Data(updatedData);
      appEvents.observedChampionsChanged.notify();
      events.add(
        newObserving
            ? ChampionDetailsEvent.championObserved
            : ChampionDetailsEvent.championUnobserved,
      );
    } catch (_) {
      events.add(ChampionDetailsEvent.observingFailed);
      _state = Data(currentData);
    }
  }
}
