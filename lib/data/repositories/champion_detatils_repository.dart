import 'dart:async';

import '../../core/model/champion.dart';
import '../api_client.dart';
import '../cache/data_cache.dart';
import '../services/error_service.dart';

class ChampionDetailsRepository {
  ChampionDetailsRepository({
    required this.apiClient,
    required this.dataCache,
    required this.errorService,
  });

  final AppApiClient apiClient;
  final DataCache dataCache;
  final ErrorService errorService;

  Future<ChampionDetails?> loadCachedChampion(String championId) async {
    try {
      return await dataCache.loadChampionDetails(championId);
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
      rethrow;
    }
  }

  Future<ChampionDetails> refreshChampion(String championId) async {
    try {
      final champion = await apiClient.championDetails(championId: championId);
      unawaited(_cacheChampion(champion));
      return champion;
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
      rethrow;
    }
  }

  Future<void> observeChampion(String championId, bool observing) async {
    try {
      final input = ObserveChampionInput(observing: observing);
      await apiClient.observeChampion(championId, input);
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
      rethrow;
    }
  }

  Future<void> _cacheChampion(ChampionDetails champion) async {
    try {
      await dataCache.saveChampionDetails(champion);
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
    }
  }
}
