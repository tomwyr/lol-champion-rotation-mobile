import 'dart:async';

import '../../../common/base_cubit.dart';
import '../../../data/repositories/champion_detatils_repository.dart';
import '../../events.dart';
import '../../state.dart';
import 'champion_details_state.dart';

class ChampionDetailsCubit extends BaseCubit<ChampionDetailsState> {
  ChampionDetailsCubit({required this.appEvents, required this.repository}) : super(Initial());

  final AppEvents appEvents;
  final ChampionDetailsRepository repository;

  final StreamController<ChampionDetailsEvent> events = .broadcast();

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
    final cacheLoaded = await _loadCachedChampion();
    final freshLoaded = await _refreshChampion();
    if (cacheLoaded && !freshLoaded) {
      events.add(.refreshFailed);
    } else if (!cacheLoaded && !freshLoaded) {
      emit(Error());
    }
  }

  Future<bool> _loadCachedChampion() async {
    try {
      final cachedData = await repository.loadCachedChampion(_championId);
      if (cachedData != null) {
        emit(Data(ChampionDetailsData(champion: cachedData)));
        return true;
      }
    } catch (_) {
      // Ignore
    }
    return false;
  }

  Future<bool> _refreshChampion() async {
    void emitRefreshing(bool value) {
      if (state case Data(value: var currentData)) {
        emit(Data(currentData, refreshing: value));
      }
    }

    emitRefreshing(true);
    try {
      final championDetails = await repository.refreshChampion(_championId);
      emit(Data(ChampionDetailsData(champion: championDetails)));
      return true;
    } catch (_) {
      emitRefreshing(false);
    }
    return false;
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
      await repository.observeChampion(_championId, newObserving);
      final updatedData = currentData.withObserving(newObserving);
      emit(Data(updatedData));
      appEvents.observedChampionsChanged.notify();
      events.add(newObserving ? .championObserved : .championUnobserved);
    } catch (_) {
      events.add(.observingFailed);
      emit(Data(currentData));
    }
  }
}
