import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/application/champion_details/champion_details_cubit.dart';
import '../../core/application/champion_details/champion_details_state.dart';
import '../../core/model/champion.dart';
import '../../core/state.dart';
import '../../dependencies/locate.dart';
import '../app/app_notifications.dart';
import '../common/utils/extensions.dart';
import '../common/utils/routes.dart';
import '../common/widgets/data_states.dart';
import '../common/widgets/events_listener.dart';
import '../common/widgets/lifecycle.dart';
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

  static void push(
    BuildContext context, {
    required ChampionSummary champion,
    Object? heroDiscriminator,
  }) {
    context.pushDefaultRoute(
      BlocProvider(
        create: (_) => locateNew<ChampionDetailsCubit>(),
        child: ChampionDetailsPage(
          champion: champion,
          heroDiscriminator: heroDiscriminator,
        ),
      ),
    );
  }

  final ChampionSummary champion;
  final Object? heroDiscriminator;

  @override
  State<ChampionDetailsPage> createState() => _ChampionDetailsPageState();
}

class _ChampionDetailsPageState extends State<ChampionDetailsPage> {
  final overlapHandle = SliverOverlapAbsorberHandle();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ChampionDetailsCubit>();

    return Lifecycle(
      onInit: () => cubit.initialize(widget.champion.id),
      child: EventsListener(
        events: cubit.events.stream,
        onEvent: onEvent,
        child: Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverOverlapAbsorber(
                  handle: overlapHandle,
                  sliver: _appBar(cubit),
                ),
                SliverOverlapInjector(handle: overlapHandle),
                _body(cubit),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar(ChampionDetailsCubit cubit) {
    return ChampionDetailsAppBar(
      champion: widget.champion,
      heroDiscriminator: widget.heroDiscriminator,
      details: switch (cubit.state) {
        Data(:var value) => value.champion,
        _ => null,
      },
      appBarTrailing: switch (cubit.state) {
        Data(:var value) => IconButton(
            onPressed: !value.togglingObserved ? cubit.toggleObserved : null,
            icon: Icon(
              value.champion.observing ? Icons.visibility : Icons.visibility_outlined,
            ),
          ),
        _ => null,
      },
    );
  }

  Widget _body(ChampionDetailsCubit cubit) {
    return switch (cubit.state) {
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
        notifications.showSuccess(
          message: "Champion added to observed.",
          duration: AppNotificationDuration.short,
        );
      case ChampionDetailsEvent.championUnobserved:
        notifications.showSuccess(
          message: "Champion removed from observed.",
          duration: AppNotificationDuration.short,
        );
    }
  }
}
