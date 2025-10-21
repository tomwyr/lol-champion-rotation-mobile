import '../../../common/base_cubit.dart';
import '../../../common/utils/cancelable.dart';
import '../../../common/utils/functions.dart';
import '../../../data/api_client.dart';
import '../../state.dart';
import 'search_champions_state.dart';

class SearchChampionsCubit extends BaseCubit<SearchChampionsState> {
  SearchChampionsCubit({required this.apiClient}) : super(Initial());

  final AppApiClient apiClient;

  final _activeSearch = CancelableTask();

  var _lastQuery = '';

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
    await delay(milliseconds: 500);
    if (task.canceled) return;

    emit(Loading());

    try {
      final result = await apiClient.searchChampions(championName: query);
      if (task.canceled) return;
      emit(Data(result));
    } catch (_) {
      emit(Error());
    }
  }
}
