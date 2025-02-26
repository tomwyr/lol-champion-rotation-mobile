import 'package:flutter/material.dart';

import '../../core/model/champion.dart';
import '../../core/state.dart';
import '../../core/stores/champion_details.dart';
import '../../dependencies/locate.dart';
import '../common/widgets/data_states.dart';
import 'champion_details_app_bar.dart';
import 'champion_details_rotations.dart';

class ChampionDetailsPage extends StatefulWidget {
  const ChampionDetailsPage({
    super.key,
    required this.champion,
  });

  final Champion champion;

  @override
  State<ChampionDetailsPage> createState() => _ChampionDetailsPageState();
}

class _ChampionDetailsPageState extends State<ChampionDetailsPage> {
  final overlapHandle = SliverOverlapAbsorberHandle();

  late final ChampionDetailsStore store;

  @override
  void initState() {
    super.initState();
    store = locateScoped<ChampionDetailsStore>(this);
    store.initialize(widget.champion.id);
  }

  @override
  void dispose() {
    resetScoped<ChampionDetailsStore>(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: store.state,
          builder: (context, value, child) => CustomScrollView(
            slivers: [
              SliverOverlapAbsorber(
                handle: overlapHandle,
                sliver: _appBar(value),
              ),
              SliverOverlapInjector(handle: overlapHandle),
              _body(value),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar(ChampionDetailsState state) {
    return ChampionDetailsAppBar(
      champion: widget.champion,
      details: switch (state) {
        Data(:var value) => value,
        _ => null,
      },
    );
  }

  Widget _body(ChampionDetailsState state) {
    return switch (state) {
      Initial() || Loading() => const DataLoading(sliver: true),
      Error() => const DataError(
          sliver: true,
          message: "We couldn't retrieve the champion data. Please try again later.",
        ),
      Data(:var value) => SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(
            child: ChampionDetailsRotations(details: value),
          ),
        ),
    };
  }
}
