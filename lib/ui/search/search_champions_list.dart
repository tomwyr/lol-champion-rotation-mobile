import 'package:flutter/material.dart';

import '../../core/stores/search_champions.dart';
import '../rotation/champions_list.dart';
import '../utils/extensions.dart';
import '../utils/formatters.dart';

class SearchChampionsList extends StatelessWidget {
  const SearchChampionsList({
    super.key,
    required this.data,
  });

  final SearchChampionsData data;

  @override
  Widget build(BuildContext context) {
    final isFallback = data.source == SearchChampionsSource.fallback;

    return ChampionsList(
      rotations: _rotations(),
      headerSliver: isFallback ? fallbackInfo() : null,
      placeholder: "No champions match your search query.",
    );
  }

  List<ChampionsListRotationData> _rotations() {
    return [
      if (data.regularRotations.isNotEmpty)
        for (var rotation in data.regularRotations)
          (
            title: rotation.duration?.format(),
            champions: rotation.champions,
            // TODO Handle current rotation
            current: false,
          ),
      if (data.beginnerRotations.isNotEmpty)
        for (var rotation in data.beginnerRotations)
          (
            title: rotation.duration?.format(),
            champions: rotation.champions,
            current: false,
          )
    ];
  }

  Widget fallbackInfo() {
    // TODO Show fallback info
    return const Text("Fallback data").sliver;
  }
}
