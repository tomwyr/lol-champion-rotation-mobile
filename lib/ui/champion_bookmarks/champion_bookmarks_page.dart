import 'package:flutter/material.dart';

import '../../core/state.dart';
import '../../core/stores/champion_bookmarks.dart';
import '../../dependencies/locate.dart';
import '../common/widgets/data_states.dart';
import 'champion_bookmarks_data.dart';

class ChampionBookmarksPage extends StatefulWidget {
  const ChampionBookmarksPage({super.key});

  @override
  State<ChampionBookmarksPage> createState() => _ChampionBookmarksPageState();
}

class _ChampionBookmarksPageState extends State<ChampionBookmarksPage> {
  late final ChampionBookmarksStore store;

  @override
  void initState() {
    super.initState();
    store = locateScoped(this);
    store.loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Observed champions'),
      ),
      body: ValueListenableBuilder(
        valueListenable: store.state,
        builder: (context, value, child) => switch (value) {
          Initial() || Loading() => const DataLoading(),
          Error() => const DataError(
              message: "We couldn't retrieve the observed champions. Please try again later.",
            ),
          Data(:var value) => ChampionBookmarksData(
              champions: value,
              onRefresh: store.loadBookmarks,
            ),
        },
      ),
    );
  }
}
