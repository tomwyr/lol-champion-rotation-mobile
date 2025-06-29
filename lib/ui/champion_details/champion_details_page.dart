import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../core/model/champion.dart';
import '../../core/state.dart';
import '../../core/stores/champion_details/champion_details_state.dart';
import '../../core/stores/champion_details/champion_details_store.dart';
import '../../dependencies/locate.dart';
import '../app/app_notifications.dart';
import '../common/utils/extensions.dart';
import '../common/widgets/data_states.dart';
import '../common/widgets/events_listener.dart';
import 'sections/history.dart';
import 'sections/overview.dart';
import 'sections/rotations.dart';
import 'widgets/app_bar.dart';

class ChampionDetailsPage extends StatefulWidget {
  const ChampionDetailsPage({
    super.key,
    required this.champion,
    this.heroDiscriminator,
  });

  final ChampionSummary champion;
  final Object? heroDiscriminator;

  @override
  State<ChampionDetailsPage> createState() => _ChampionDetailsPageState();
}

class _ChampionDetailsPageState extends State<ChampionDetailsPage> {
  final overlapHandle = SliverOverlapAbsorberHandle();

  late final ChampionDetailsStore store;

  @override
  void initState() {
    super.initState();
    store = locateScoped(this);
    store.initialize(widget.champion.id);
  }

  @override
  void dispose() {
    resetScoped<ChampionDetailsStore>(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EventsListener(
      events: store.events.stream,
      onEvent: onEvent,
      child: Scaffold(
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final state = store.state;

              return CustomScrollView(
                slivers: [
                  SliverOverlapAbsorber(
                    handle: overlapHandle,
                    sliver: _appBar(state),
                  ),
                  SliverOverlapInjector(handle: overlapHandle),
                  _body(state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _appBar(ChampionDetailsState state) {
    return ChampionDetailsAppBar(
      champion: widget.champion,
      heroDiscriminator: widget.heroDiscriminator,
      details: switch (state) {
        Data(:var value) => value.champion,
        _ => null,
      },
      appBarTrailing: switch (state) {
        Data(:var value) => IconButton(
            onPressed: !value.togglingObserved ? store.toggleObserved : null,
            icon: Icon(
              value.champion.observing ? Icons.visibility : Icons.visibility_outlined,
            ),
          ),
        _ => null,
      },
    );
  }

  Widget _body(ChampionDetailsState state) {
    return switch (state) {
      Initial() || Loading() => const DataLoading(sliver: true),
      Error() => const DataError(
          sliver: true,
          message: "Failed to retrieve champion data. Please try again later.",
        ),
      Data(:var value) => SliverPadding(
          padding: const EdgeInsets.only(top: 12, bottom: 4),
          sliver: SliverMainAxisGroup(
            slivers: [
              for (var section in [
                ChampionDetailsRotationsSection(details: value.champion),
                ChampionDetailsOverviewSection(details: value.champion),
                ChampionDetailsHistorySection(details: value.champion),
              ])
                SliverToBoxAdapter(child: section),
            ].gapped(vertically: 12, sliver: true),
          ),
        ),
    };
  }

  void onEvent(ChampionDetailsEvent event, AppNotificationsState notifications) {
    switch (event) {
      case ChampionDetailsEvent.observingFailed:
        notifications.showError(
          message: "Failed to update champion tracking. Please try again later.",
        );
      case ChampionDetailsEvent.championObserved:
        notifications.showSuccess(message: "Champion added to observed.");
      case ChampionDetailsEvent.championUnobserved:
        notifications.showSuccess(message: "Champion removed from observed.");
    }
  }
}
