import 'package:flutter/material.dart';

import '../../core/state.dart';
import '../../core/stores/observed_champions.dart';
import '../../dependencies/locate.dart';
import '../common/widgets/data_states.dart';
import 'observed_champions_data.dart';

class ObservedChampionsPage extends StatefulWidget {
  const ObservedChampionsPage({super.key});

  @override
  State<ObservedChampionsPage> createState() => _ObservedChampionsPageState();
}

class _ObservedChampionsPageState extends State<ObservedChampionsPage> {
  late final ObservedChampionsStore store;

  @override
  void initState() {
    super.initState();
    store = locateScoped(this);
    store.loadChampions();
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
          Data(:var value) => ObservedChampionsData(
              champions: value,
              onRefresh: store.loadChampions,
            ),
        },
      ),
    );
  }
}
