import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/api_client.dart';
import '../../events.dart';
import '../../model/champion.dart';
import '../../state.dart';
import 'champion_details_state.dart';

class ChampionDetailsCubit extends Cubit<ChampionDetailsState> {
  ChampionDetailsCubit({
    required this.appEvents,
    required this.apiClient,
  }) : super(Initial());

  final AppEvents appEvents;
  final AppApiClient apiClient;

  final StreamController<ChampionDetailsEvent> events = StreamController.broadcast();

  late String _championId;

  void initialize(String championId) {
    _championId = championId;
    _loadChampion();
  }

  Future<void> _loadChampion() async {
    if (state case Loading()) {
      return;
    }

    emit(Loading());

    try {
      final championDetails = await apiClient.championDetails(championId: _championId);
      emit(Data(ChampionDetailsData(champion: championDetails)));
    } catch (_) {
      emit(Error());
    }
  }

  Future<void> toggleObserved() async {
    final ChampionDetailsData currentData;
    if (state case Data(:var value) when !value.togglingObserved) {
      currentData = value;
    } else {
      return;
    }

    emit(Data(currentData.copyWith(togglingObserved: true)));
    try {
      final newObserving = !currentData.champion.observing;
      final input = ObserveChampionInput(observing: newObserving);
      await apiClient.observeChampion(_championId, input);
      final updatedData = currentData.copyWith(
        champion: currentData.champion.copyWith(observing: newObserving),
      );
      emit(Data(updatedData));
      appEvents.observedChampionsChanged.notify();
      events.add(
        newObserving
            ? ChampionDetailsEvent.championObserved
            : ChampionDetailsEvent.championUnobserved,
      );
    } catch (_) {
      events.add(ChampionDetailsEvent.observingFailed);
      emit(Data(currentData));
    }
  }
}
