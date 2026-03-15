import 'dart:async';

import '../../../common/base_cubit.dart';
import '../../../data/api_client.dart';
import '../../../data/cache/data_cache.dart';
import '../../../data/services/error_service.dart';
import '../../events.dart';
import '../../model/rotation.dart';
import '../../state.dart';
import 'rotation_details_state.dart';

class RotationDetailsCubit extends BaseCubit<RotationDetailsState> {
  RotationDetailsCubit({
    required this.appEvents,
    required this.apiClient,
    required this.dataCache,
    required this.errorService,
  }) : super(Initial());

  final AppEvents appEvents;
  final AppApiClient apiClient;
  final DataCache dataCache;
  final ErrorService errorService;

  final StreamController<RotationDetailsEvent> events = .broadcast();

  late String _rotationId;

  void initialize(String rotationId) {
    _rotationId = rotationId;
    _loadRotation();
  }

  Future<void> _loadRotation() async {
    if (state case Loading()) {
      return;
    }

    emit(Loading());
    final cacheLoaded = await _loadCachedRotation();
    final freshLoaded = await _refreshRotation();
    if (cacheLoaded && !freshLoaded) {
      events.add(.refreshFailed);
    } else if (!cacheLoaded && !freshLoaded) {
      emit(Error());
    }
  }

  Future<bool> _loadCachedRotation() async {
    var success = false;
    try {
      final cachedData = await dataCache.loadRotationDetails(_rotationId);
      if (cachedData != null) {
        emit(Data(RotationDetailsData(rotation: cachedData)));
        success = true;
      }
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
    }
    return success;
  }

  Future<bool> _refreshRotation() async {
    void emitRefreshing(bool value) {
      if (state case Data(value: var currentData)) {
        emit(Data(currentData.copyWith(refreshing: value)));
      }
    }

    var success = false;
    emitRefreshing(true);
    try {
      final rotation = await apiClient.rotation(rotationId: _rotationId);
      _cacheRotation(rotation);
      emit(Data(RotationDetailsData(rotation: rotation)));
      success = true;
    } catch (error, stackTrace) {
      emitRefreshing(false);
      errorService.reportSilent(error, stackTrace);
    }
    return success;
  }

  Future<void> _cacheRotation(ChampionRotationDetails rotation) async {
    try {
      await dataCache.saveRotationDetails(rotation);
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
    }
  }

  Future<void> toggleObserved() async {
    final RotationDetailsData currentData;
    if (state case Data(:var value) when !value.togglingObserved) {
      currentData = value;
    } else {
      return;
    }

    emit(Data(currentData.copyWith(togglingObserved: true)));
    try {
      final newObserving = !currentData.rotation.observing;
      final input = ObserveRotationInput(observing: newObserving);
      await apiClient.observeRotation(_rotationId, input);
      final updatedData = currentData.copyWith(
        rotation: currentData.rotation.copyWith(observing: newObserving),
      );
      emit(Data(updatedData));
      appEvents.observedRotationsChanged.notify();
      events.add(newObserving ? .rotationObserved : .rotationUnobserved);
    } catch (error, stackTrace) {
      errorService.reportSilent(error, stackTrace);
      events.add(.observingFailed);
      emit(Data(currentData));
    }
  }
}
