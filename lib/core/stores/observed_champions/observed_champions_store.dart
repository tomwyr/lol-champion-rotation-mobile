import 'package:mobx/mobx.dart';

import '../../../data/api_client.dart';
import '../../events.dart';
import '../../model/champion.dart';
import '../../state.dart';
import 'observed_champions_state.dart';

part 'observed_champions_store.g.dart';

class ObservedChampionsStore extends _ObservedChampionsStore with _$ObservedChampionsStore {
  ObservedChampionsStore({
    required super.appEvents,
    required super.apiClient,
  });
}

abstract class _ObservedChampionsStore with Store {
  _ObservedChampionsStore({
    required this.appEvents,
    required this.apiClient,
  }) {
    appEvents.observedChampionsChanged.addListener(loadChampions);
  }

  final AppApiClient apiClient;
  final AppEvents appEvents;

  @readonly
  ObservedChampionsState _state = Initial();

  @action
  Future<void> loadChampions() async {
    if (_state case Loading()) {
      return;
    }

    _state = Loading();
    try {
      final data = await apiClient.observedChampions();
      _state = Data(data.champions);
    } catch (_) {
      _state = Error();
    }
  }
}
