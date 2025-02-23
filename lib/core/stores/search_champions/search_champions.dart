import 'package:flutter/foundation.dart';

import '../../../common/utils/cancelable.dart';
import '../../../common/utils/functions.dart';
import '../../../data/api_client.dart';
import '../../model/rotation.dart';
import '../../state.dart';

class SearchChampionsStore {
  SearchChampionsStore({required this.apiClient});

  final AppApiClient apiClient;

  final ValueNotifier<SearchChampionsState> state = ValueNotifier(Initial());

  final _activeSearch = CancelableSwitcher();

  var _lastQuery = '';

  void updateQuery(String query) async {
    query = query.trim();
    if (query == _lastQuery) {
      return;
    }
    _lastQuery = query;
    if (query.isEmpty) {
      _activeSearch.cancel();
      return;
    }

    final task = _activeSearch.startNew();
    await delay(milliseconds: 500);
    if (task.canceled) return;

    state.value = Loading();

    try {
      final result = await apiClient.searchChampions(championName: query);
      if (task.canceled) return;
      state.value = Data(result);
    } catch (_) {
      state.value = Error();
    }
  }
}

typedef SearchChampionsState = DataState<SearchChampionsResult>;
