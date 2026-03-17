import 'dart:async';

import '../../../common/base_cubit.dart';
import '../../../data/api_client.dart';
import '../../../data/cache/data_cache.dart';
import '../../../data/services/error_service.dart';
import '../../events.dart';
import '../../model/champion.dart';
import '../../state.dart';
import 'champion_details_state.dart';

class ChampionDetailsCubit extends BaseCubit<ChampionDetailsState> {
  ChampionDetailsCubit({
    required this.appEvents,
    required this.apiClient,
    required this.dataCache,
    required this.errorService,
  }) : super(Initial());

  final AppEvents appEvents;
  final AppApiClient apiClient;
  final DataCache dataCache;
  final ErrorService errorService;

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
    var success = false;
    try {
      final cachedData = await dataCache.loadChampionDetails(_championId);
      if (cachedData != null) {
        emit(Data(ChampionDetailsData(champion: cachedData)));
        success = true;
      }
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
    }
    return success;
  }

  Future<bool> _refreshChampion() async {
    void emitRefreshing(bool value) {
      if (state case Data(value: var currentData)) {
        emit(Data(currentData, refreshing: value));
      }
    }

    var success = false;
    emitRefreshing(true);
    try {
      final championDetails = await apiClient.championDetails(championId: _championId);
      unawaited(_cacheChampion(championDetails));
      emit(Data(ChampionDetailsData(champion: championDetails)));
      success = true;
    } catch (error, stackTrace) {
      emitRefreshing(false);
      errorService.reportSilent(error, stackTrace);
    }
    return success;
  }

  Future<void> _cacheChampion(ChampionDetails championDetails) async {
    try {
      await dataCache.saveChampionDetails(championDetails);
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
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
      events.add(newObserving ? .championObserved : .championUnobserved);
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
      events.add(.observingFailed);
      emit(Data(currentData));
    }
  }
}
