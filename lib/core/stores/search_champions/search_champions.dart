import 'package:flutter/foundation.dart';

import '../../../common/utils/cancelable.dart';
import '../../../common/utils/functions.dart';
import '../../../data/api_client.dart';
import '../../model/rotation.dart';
import '../../state.dart';
import 'rotations_data_filter.dart';
import '../rotation.dart';

class SearchChampionsStore {
  SearchChampionsStore({required this.apiClient});

  final AppApiClient apiClient;

  final ValueNotifier<SearchChampionsState> state = ValueNotifier(Initial());

  final _activeSearch = CancelableSwitcher();

  RotationData? _localData;
  var _lastQuery = '';

  void initialize(RotationData? localData) {
    _localData = localData;
    state.value = Initial();
  }

  void updateQuery(String query) async {
    final task = _activeSearch.startNew();

    await delay(milliseconds: 500);
    if (task.canceled) return;

    query = query.trim();
    final skipQuery = query.isEmpty || query == _lastQuery;
    _lastQuery = query;
    if (skipQuery) {
      return;
    }

    state.value = Loading();

    try {
      final filterResult = await _filterDataByQuery(query);
      if (task.canceled) return;
      state.value = Data(filterResult);
    } catch (_) {
      state.value = Error();
    }
  }

  Future<SearchChampionsData> _filterDataByQuery(String query) async {
    try {
      return await _filterRemoteData(query);
    } catch (_) {
      if (_localData case var data?) {
        return _filterLocalData(data);
      } else {
        rethrow;
      }
    }
  }

  Future<SearchChampionsData> _filterRemoteData(String query) async {
    final result = await apiClient.searchRotations(championName: query);
    return SearchChampionsData(
      regularRotations: result.regularRotations,
      beginnerRotation: result.beginnerRotation,
      source: SearchChampionsSource.primary,
    );
  }

  SearchChampionsData _filterLocalData(RotationData localData) {
    final filter = RotationsDataFilter(data: localData, query: _lastQuery);
    return SearchChampionsData(
      regularRotations: filter.filterRegularRotations(),
      beginnerRotation: filter.filterBeginnerRotation(),
      source: SearchChampionsSource.fallback,
    );
  }
}

typedef SearchChampionsState = DataState<SearchChampionsData>;

class SearchChampionsData {
  SearchChampionsData({
    required this.regularRotations,
    required this.beginnerRotation,
    required this.source,
  });

  final List<FilteredRegularRotation> regularRotations;
  final FilteredBeginnerRotation? beginnerRotation;
  final SearchChampionsSource source;
}

enum SearchChampionsSource { primary, fallback }
