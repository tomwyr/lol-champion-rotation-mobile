import 'package:flutter/material.dart';

import '../../core/state.dart';
import '../../core/stores/observed_rotations.dart';
import '../../dependencies/locate.dart';
import '../common/widgets/data_states.dart';
import 'observed_rotations_data.dart';

class ObservedRotationsPage extends StatefulWidget {
  const ObservedRotationsPage({super.key});

  @override
  State<ObservedRotationsPage> createState() => _ObservedRotationsPageState();
}

class _ObservedRotationsPageState extends State<ObservedRotationsPage> {
  late final ObservedRotationsStore store;

  @override
  void initState() {
    super.initState();
    store = locateScoped(this);
    store.loadRotations();
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
          Data(:var value) => ObservedRotationsData(
              rotations: value,
              onRefresh: store.loadRotations,
            ),
        },
      ),
    );
  }
}
