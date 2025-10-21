import 'dart:async';

import '../../../common/base_cubit.dart';
import '../../../data/api_client.dart';
import '../../events.dart';
import '../../state.dart';
import 'observed_champions_state.dart';

class ObservedChampionsCubit extends BaseCubit<ObservedChampionsState> {
  ObservedChampionsCubit({
    required this.appEvents,
    required this.apiClient,
  }) : super(Initial()) {
    appEvents.observedChampionsChanged.addListener(loadChampions);
  }

  final AppApiClient apiClient;
  final AppEvents appEvents;

  Future<void> loadChampions() async {
    if (state case Loading()) {
      return;
    }

    emit(Loading());
    try {
      final data = await apiClient.observedChampions();
      emit(Data(data.champions));
    } catch (_) {
      emit(Error());
    }
  }

  @override
  Future<void> close() {
    appEvents.observedChampionsChanged.removeListener(loadChampions);
    return super.close();
  }
}
