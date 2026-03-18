import 'dart:async';

import '../../core/model/rotation.dart';
import '../api_client.dart';
import '../cache/data_cache.dart';
import '../services/error_service.dart';

class RotationDetailsRepository {
  RotationDetailsRepository({
    required this.apiClient,
    required this.dataCache,
    required this.errorService,
  });

  final AppApiClient apiClient;
  final DataCache dataCache;
  final ErrorService errorService;

  Future<ChampionRotationDetails?> loadCachedRotation(String rotationId) async {
    try {
      return await dataCache.loadRotationDetails(rotationId);
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
      rethrow;
    }
  }

  Future<ChampionRotationDetails> refreshRotation(String rotationId) async {
    try {
      final rotation = await apiClient.rotation(rotationId: rotationId);
      unawaited(_cacheRotation(rotation));
      return rotation;
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
      rethrow;
    }
  }

  Future<void> observeRotation(String rotationId, bool observing) async {
    try {
      final input = ObserveRotationInput(observing: observing);
      await apiClient.observeRotation(rotationId, input);
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
      rethrow;
    }
  }

  Future<void> _cacheRotation(ChampionRotationDetails rotation) async {
    try {
      await dataCache.saveRotationDetails(rotation);
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
    }
  }
}
