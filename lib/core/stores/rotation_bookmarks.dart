import 'package:flutter/foundation.dart';

import '../../data/api_client.dart';
import '../events.dart';
import '../model/rotation.dart';
import '../state.dart';

class RotationBookmarksStore {
  RotationBookmarksStore({
    required this.appEvents,
    required this.apiClient,
  }) {
    appEvents.rotationBookmarkChanged.addListener(loadBookmarks);
  }

  final AppApiClient apiClient;
  final AppEvents appEvents;

  final ValueNotifier<RotationBookmarksState> state = ValueNotifier(Initial());

  Future<void> loadBookmarks() async {
    if (state.value case Loading()) {
      return;
    }

    state.value = Loading();
    try {
      final data = await apiClient.observedRotations();
      state.value = Data(data.rotations);
    } catch (_) {
      state.value = Error();
    }
  }
}

typedef RotationBookmarksState = DataState<List<ObservedRotation>>;
