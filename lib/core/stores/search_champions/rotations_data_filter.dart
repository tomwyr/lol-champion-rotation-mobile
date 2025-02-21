import '../../model/rotation.dart';
import '../rotation.dart';

class RotationsDataFilter {
  RotationsDataFilter({
    required this.data,
    required this.query,
  });

  final RotationData data;
  final String query;

  late final _effectiveQuery = query.trim().toLowerCase();
  bool get _applyQuery => _effectiveQuery.isNotEmpty;

  List<FilteredRegularRotation> filterRegularRotations() {
    final rotations = _mapRegularRotations();
    if (!_applyQuery) {
      return rotations;
    }

    return rotations
        .map((rotation) {
          final filteredChampions = _filterByQuery(rotation.champions);
          return rotation.copyWith(champions: filteredChampions);
        })
        .where((rotation) => rotation.champions.isNotEmpty)
        .toList();
  }

  FilteredBeginnerRotation? filterBeginnerRotation() {
    final rotation = _mapBeginnerRotation();
    if (!_applyQuery) {
      return rotation;
    }

    final filteredChampions = _filterByQuery(rotation.champions);
    if (filteredChampions.isEmpty) {
      return null;
    }

    return rotation.copyWith(champions: filteredChampions);
  }

  List<Champion> _filterByQuery(List<Champion> champions) {
    return champions.where((champion) => champion.name.toLowerCase().contains(query)).toList();
  }

  List<FilteredRegularRotation> _mapRegularRotations() {
    return [
      FilteredRegularRotation(
        duration: data.currentRotation.duration,
        champions: data.currentRotation.regularChampions,
        current: true,
      ),
      for (var rotation in data.nextRotations)
        FilteredRegularRotation(
          duration: rotation.duration,
          champions: rotation.champions,
          current: false,
        ),
    ];
  }

  FilteredBeginnerRotation _mapBeginnerRotation() {
    return FilteredBeginnerRotation(
      champions: data.currentRotation.beginnerChampions,
    );
  }
}
