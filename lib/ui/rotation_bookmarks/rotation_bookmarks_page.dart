import 'package:flutter/material.dart';

import '../../core/state.dart';
import '../../core/stores/rotation_bookmarks.dart';
import '../../dependencies/locate.dart';
import '../common/widgets/data_states.dart';
import 'rotation_bookmarks_data.dart';

class RotationBookmarksPage extends StatefulWidget {
  const RotationBookmarksPage({super.key});

  @override
  State<RotationBookmarksPage> createState() => _RotationBookmarksPageState();
}

class _RotationBookmarksPageState extends State<RotationBookmarksPage> {
  late final RotationBookmarksStore store;

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
        title: const Text('Bookmarked rotations'),
      ),
      body: ValueListenableBuilder(
        valueListenable: store.state,
        builder: (context, value, child) => switch (value) {
          Initial() || Loading() => const DataLoading(),
          Error() => const DataError(
              message: "We couldn't retrieve the rotations bookmarks. Please try again later.",
            ),
          Data(:var value) => RotationBookmarksData(
            rotations: value,
            onRefresh: store.loadBookmarks,
          ),
        },
      ),
    );
  }
}
