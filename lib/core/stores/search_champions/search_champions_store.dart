import 'package:mobx/mobx.dart';

import '../../../common/utils/cancelable.dart';
import '../../../common/utils/functions.dart';
import '../../../data/api_client.dart';
import '../../model/champion.dart';
import '../../state.dart';
import 'search_champions_state.dart';

part 'search_champions_store.g.dart';

class SearchChampionsStore extends _SearchChampionsStore with _$SearchChampionsStore {
  SearchChampionsStore({required super.apiClient});
}

abstract class _SearchChampionsStore with Store {
  _SearchChampionsStore({required this.apiClient});

  final AppApiClient apiClient;

  @readonly
  SearchChampionsState _state = Initial();

  final _activeSearch = CancelableTask();

  var _lastQuery = '';

  @action
  Future<void> updateQuery(String query) async {
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
    await delay(milliseconds: 700);
    if (task.canceled) return;

    _state = Loading();

    try {
      final result = await apiClient.searchChampions(championName: query);
      if (task.canceled) return;
      _state = Data(result);
    } catch (_) {
      _state = Error();
    }
  }
}
