import 'dart:async';

import '../../core/model/rotation.dart';
import '../../core/model/rotations_data.dart';
import '../api_client.dart';
import '../cache/data_cache.dart';
import '../services/error_service.dart';
import '../services/local_settings_service.dart';

class RotationPredictionUnavailable implements Exception {}

typedef RefreshRotationsResult = (RotationsData rotationsData, bool rotationPredictionError);

class RotationsRepository {
  RotationsRepository({
    required this.apiClient,
    required this.dataCache,
    required this.localSettingsService,
    required this.errorService,
  });

  final AppApiClient apiClient;
  final DataCache dataCache;
  final LocalSettingsService localSettingsService;
  final ErrorService errorService;

  Future<RotationsData?> loadCachedRotations() async {
    try {
      return await dataCache.loadRotationsData();
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
      rethrow;
    }
  }

  Future<RefreshRotationsResult> refreshRotations() async {
    try {
      final rotationsOverview = await apiClient.rotationsOverview();
      final nextRotationToken = rotationsOverview.nextRotationToken;
      final (nextRotations, (rotationPrediction, rotationPredictionError)) = await (
        _fetchNextRotations(token: nextRotationToken, count: 3),
        _loadRotationPredictionWithStatus(),
      ).wait;
      final rotationsData = RotationsData(
        rotationsOverview: rotationsOverview,
        rotationPrediction: rotationPrediction,
        nextRotations: nextRotations,
      );
      unawaited(_cacheRotations(rotationsData));
      return (rotationsData, rotationPredictionError);
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
      rethrow;
    }
  }

  Future<RefreshRotationsResult> refreshRotationsOverview(RotationsData currentData) async {
    try {
      final rotationsOverview = await apiClient.rotationsOverview();
      final (formerCurrentRotation, (rotationPrediction, rotationPredictionError)) = await (
        _loadFormerCurrentRotation(currentData, rotationsOverview),
        _loadRotationPredictionWithStatus(),
      ).wait;
      final nextRotations = [?formerCurrentRotation, ...currentData.nextRotations];
      final updatedData = currentData.copyWith(
        rotationsOverview: rotationsOverview,
        rotationPrediction: rotationPrediction,
        nextRotations: nextRotations,
      );
      unawaited(_cacheRotations(updatedData));
      return (updatedData, rotationPredictionError);
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
      rethrow;
    }
  }

  Future<RotationsData> loadNextRotation(RotationsData currentData) async {
    try {
      final token = currentData.nextRotationToken!;
      final nextRotation = await apiClient.nextRotation(token: token);
      final updatedData = currentData.appendingNext(nextRotation);
      unawaited(_cacheRotations(updatedData));
      return updatedData;
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
      rethrow;
    }
  }

  Future<ChampionRotationPrediction?> loadRotationPrediction() async {
    try {
      final predictionsEnabled = await localSettingsService.getPredictionsEnabled();
      if (!predictionsEnabled) {
        return null;
      }
      return await apiClient.predictRotation();
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
      rethrow;
    }
  }

  Future<List<ChampionRotation>> _fetchNextRotations({
    required String? token,
    required int count,
  }) async {
    if (token == null) return [];
    return await apiClient.nextRotations(token: token, count: count);
  }

  /// Fetches the next rotation to prevent losing the previously current one
  /// when refreshed data contains a newer rotation.
  Future<ChampionRotation?> _loadFormerCurrentRotation(
    RotationsData? currentData,
    ChampionRotationsOverview refreshedOverview,
  ) async {
    // Skip for the initial data fetch.
    if (currentData == null) return null;

    final rotationChanged = currentData.rotationsOverview.id != refreshedOverview.id;
    final token = refreshedOverview.nextRotationToken;
    if (!rotationChanged || token == null) {
      return null;
    }

    return await apiClient.nextRotation(token: token);
  }

  Future<(ChampionRotationPrediction?, bool)> _loadRotationPredictionWithStatus() async {
    try {
      final prediction = await loadRotationPrediction();
      return (prediction, false);
    } catch (_) {
      return (null, true);
    }
  }

  Future<void> _cacheRotations(RotationsData rotationsData) async {
    try {
      await dataCache.saveRotationsData(rotationsData);
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
    }
  }
}
