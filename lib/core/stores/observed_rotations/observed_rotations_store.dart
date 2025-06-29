import 'package:mobx/mobx.dart';

import '../../../data/api_client.dart';
import '../../events.dart';
import '../../model/rotation.dart';
import '../../state.dart';
import 'observed_rotations_state.dart';

part 'observed_rotations_store.g.dart';

class ObservedRotationsStore extends _ObservedRotationsStore with _$ObservedRotationsStore {
  ObservedRotationsStore({
    required super.appEvents,
    required super.apiClient,
  });
}

abstract class _ObservedRotationsStore with Store {
  _ObservedRotationsStore({
    required this.appEvents,
    required this.apiClient,
  }) {
    appEvents.observedRotationsChanged.addListener(loadRotations);
  }

  final AppApiClient apiClient;
  final AppEvents appEvents;

  @readonly
  ObservedRotationsState _state = Initial();

  @action
  Future<void> loadRotations() async {
    if (_state case Loading()) {
      return;
    }

    _state = Loading();
    try {
      final data = await apiClient.observedRotations();
      _state = Data(data.rotations);
    } catch (_) {
      _state = Error();
    }
  }
}
