import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/model/rotation.dart';
import '../core/stores/rotation.dart';
import '../dependencies.dart';
import 'app.dart';
import 'rotation_type.dart';
import 'utils/extensions.dart';
import 'widgets/more_data_loader.dart';

class RotationPage extends StatefulWidget {
  const RotationPage({
    super.key,
    required this.data,
    required this.onRefresh,
    required this.onLoadMore,
    required this.appBarTrailing,
  });

  final RotationData data;
  final RefreshCallback onRefresh;
  final VoidCallback onLoadMore;
  final Widget appBarTrailing;

  @override
  State<RotationPage> createState() => _RotationPageState();
}

class _RotationPageState extends State<RotationPage> {
  final controller = ScrollController();

  var searchActive = false;
  var searchQuery = "";

  var rotationType = RotationType.regular;

  CurrentChampionRotation get currentRotation => widget.data.currentRotation;
  bool get hasNextRotation => widget.data.hasNextRotation;

  @override
  Widget build(BuildContext context) {
    return _EventsListener(
      child: CustomScrollView(
        controller: controller,
        slivers: applySafeArea(
          children: [
            appBar(),
            rotationTypePicker(),
            switch (rotationType) {
              RotationType.regular => regularChampions(),
              RotationType.beginner => beginnerChampions(),
            },
            if (hasNextRotation)
              MoreDataLoader(
                controller: controller,
                onLoadMore: widget.onLoadMore,
              ),
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    return SliverAppBar(
      centerTitle: false,
      title: searchActive ? searchField() : title(),
      actions: [
        if (!searchActive) ...[
          searchButton(),
          widget.appBarTrailing,
        ],
      ],
    );
  }

  Widget searchField() {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: 'Champion name...',
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              searchQuery = "";
              searchActive = false;
            });
          },
          icon: const Icon(Icons.clear),
        ),
      ),
      onChanged: (value) {
        setState(() => searchQuery = value);
      },
    );
  }

  Widget searchButton() {
    return IconButton(
      onPressed: () {
        setState(() => searchActive = true);
      },
      icon: const Icon(Icons.search),
    );
  }

  Widget title() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        const Flexible(
          child: Text('Current rotation'),
        ),
        if (currentRotation.patchVersion case var version) ...[
          const SizedBox(width: 8),
          Text(
            'v$version',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ],
    );
  }

  Widget rotationTypePicker() {
    return RotationTypePicker(
      value: rotationType,
      onChanged: (value) {
        setState(() {
          rotationType = value;
        });
      },
    );
  }

  Widget regularChampions() {
    final champions = filterChampions(currentRotation.regularChampions);
    if (champions.isEmpty) {
      return emptyChampionsPlaceholder();
    }

    return ChampionsSection(
      title: formatDuration(),
      champions: champions,
    );
  }

  Widget beginnerChampions() {
    final champions = filterChampions(currentRotation.beginnerChampions);
    if (champions.isEmpty) {
      return emptyChampionsPlaceholder();
    }

    return ChampionsSection(
      title:
          "New players up to level ${currentRotation.beginnerMaxLevel} get access to a different pool of champions",
      champions: champions,
    );
  }

  Widget emptyChampionsPlaceholder() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: Text(
        "No champions match your search query.",
        style: Theme.of(context).textTheme.bodyLarge,
      ).sliver,
    );
  }

  List<Widget> applySafeArea({required List<Widget> children}) {
    final [first, ...middle, last] = children;

    return [
      SliverSafeArea(
        bottom: false,
        sliver: first,
      ),
      for (var sliver in middle)
        SliverSafeArea(
          top: false,
          bottom: false,
          sliver: sliver,
        ),
      SliverSafeArea(
        top: false,
        sliver: last,
      ),
    ];
  }

  String formatDuration() {
    final formatter = DateFormat('MMMM dd');

    final duration = currentRotation.duration;
    final start = formatter.format(duration.start);
    final end = formatter.format(duration.end);

    return '$start to $end';
  }

  List<Champion> filterChampions(List<Champion> champions) {
    final formattedQuery = searchQuery.trim().toLowerCase();
    if (formattedQuery.isEmpty) {
      return champions;
    } else {
      return champions
          .where((champion) => champion.name.toLowerCase().contains(formattedQuery))
          .toList();
    }
  }
}

class ChampionsSection extends StatelessWidget {
  const ChampionsSection({
    super.key,
    required this.title,
    required this.champions,
  });

  final String title;
  final List<Champion> champions;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverMainAxisGroup(
        slivers: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
            ),
          ).sliver,
          championsGrid(context)
        ],
      ),
    );
  }

  Widget championsGrid(BuildContext context) {
    return SliverGrid.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: switch (context.orientation) {
          Orientation.portrait => 2,
          Orientation.landscape => 4,
        },
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: champions.length,
      itemBuilder: (context, index) => ChampionTile(champion: champions[index]),
    );
  }
}

class ChampionTile extends StatelessWidget {
  const ChampionTile({
    super.key,
    required this.champion,
  });

  final Champion champion;

  @override
  Widget build(BuildContext context) {
    const decoration = ShapeDecoration(
      color: Colors.black54,
      shape: StadiumBorder(),
      shadows: [
        BoxShadow(
          blurRadius: 4,
          spreadRadius: 2,
          color: Colors.black38,
        ),
      ],
    );

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: CachedNetworkImage(
            imageUrl: champion.imageUrl,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: decoration,
            child: Text(
              champion.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _EventsListener extends StatefulWidget {
  const _EventsListener({required this.child});

  final Widget child;

  @override
  State<_EventsListener> createState() => _EventsListenerState();
}

class _EventsListenerState extends State<_EventsListener> {
  final store = locate<RotationStore>();

  late StreamSubscription eventsSubscription;

  AppNotifications get notifications => AppNotifications.of(context);

  @override
  void initState() {
    super.initState();
    eventsSubscription = store.events.stream.listen(onEvent);
  }

  @override
  void dispose() {
    eventsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void onEvent(RotationEvent event) {
    switch (event) {
      case RotationEvent.loadingMoreDataError:
        notifications.showError(
          message: 'Failed to load next rotation data',
        );
    }
  }
}
