import 'package:flutter/foundation.dart';

import '../../common/utils/cancelable.dart';
import '../../common/utils/functions.dart';
import '../../data/api_client.dart';
import '../model/rotation.dart';
import '../state.dart';
import 'rotation.dart';

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
      beginnerRotations: result.beginnerRotations,
      source: SearchChampionsSource.primary,
    );
  }

  SearchChampionsData _filterLocalData(RotationData localData) {
    final (:regularRotations, :beginnerRotations) = localData.toLocalFilteredRotations();
    return SearchChampionsData(
      regularRotations: _filterLocalRotations(regularRotations),
      beginnerRotations: _filterLocalRotations(beginnerRotations),
      source: SearchChampionsSource.fallback,
    );
  }

  List<FilteredRotation> _filterLocalRotations(List<FilteredRotation> rotations) {
    final query = _lastQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return rotations;
    }

    FilteredRotation filterChampionsByQuery(FilteredRotation rotation) {
      final filteredChampions = rotation.champions
          .where((champion) => champion.name.toLowerCase().contains(query))
          .toList();
      return rotation.copyWith(champions: filteredChampions);
    }

    return rotations
        .map(filterChampionsByQuery)
        .where((rotation) => rotation.champions.isNotEmpty)
        .toList();
  }
}

typedef SearchChampionsState = DataState<SearchChampionsData>;

class SearchChampionsData {
  SearchChampionsData({
    required this.regularRotations,
    required this.beginnerRotations,
    required this.source,
  });

  final List<FilteredRotation> regularRotations;
  final List<FilteredRotation> beginnerRotations;
  final SearchChampionsSource source;
}

enum SearchChampionsSource { primary, fallback }

extension on RotationData {
  ({
    List<FilteredRotation> regularRotations,
    List<FilteredRotation> beginnerRotations,
  }) toLocalFilteredRotations() {
    return (
      regularRotations: [
        FilteredRotation(
          duration: currentRotation.duration,
          champions: currentRotation.regularChampions,
          current: true,
        ),
        for (var rotation in nextRotations)
          FilteredRotation(
            duration: rotation.duration,
            champions: rotation.champions,
            current: false,
          ),
      ],
      beginnerRotations: [
        FilteredRotation(
          duration: null,
          champions: currentRotation.beginnerChampions,
          current: false,
        ),
      ],
    );
  }
}
