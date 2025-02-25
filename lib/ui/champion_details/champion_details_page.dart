import 'package:flutter/material.dart';

import '../../core/state.dart';
import '../../core/stores/champion_details.dart';
import '../../dependencies.dart';
import '../common/widgets/data_states.dart';
import 'champion_details_data.dart';

class ChampionDetailsPage extends StatefulWidget {
  const ChampionDetailsPage({
    super.key,
    required this.championId,
  });

  final String championId;

  @override
  State<ChampionDetailsPage> createState() => _ChampionDetailsPageState();
}

class _ChampionDetailsPageState extends State<ChampionDetailsPage> {
  final store = locate<ChampionDetailsStore>();

  @override
  void initState() {
    super.initState();
    store.initialize(widget.championId);
  }

  @override
  void dispose() {
    reset<ChampionDetailsStore>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: store.state,
      builder: (context, value, child) => switch (value) {
        Initial() || Loading() => Scaffold(
            appBar: AppBar(),
            body: const DataLoading(),
          ),
        Error() => Scaffold(
            appBar: AppBar(),
            body: const DataError(
              message: "We couldn't retrieve the champion data. Please try again later.",
            ),
          ),
        Data(:var value) => ChampionDetailsData(details: value),
      },
    );
  }
}
