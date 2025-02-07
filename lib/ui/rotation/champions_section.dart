import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';

import '../../core/model/rotation.dart';
import '../theme.dart';
import '../utils/extensions.dart';

class ChampionsSection extends StatelessWidget {
  const ChampionsSection({
    super.key,
    required this.title,
    this.current = false,
    required this.champions,
  });

  final String title;
  final bool current;
  final List<Champion> champions;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverStickyHeader(
        header: header(context),
        sliver: championsGrid(context),
      ),
    );
  }

  Widget header(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        child: Row(
          textBaseline: TextBaseline.alphabetic,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Flexible(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
              ),
            ),
            if (current) ...[
              const SizedBox(width: 12),
              currentBadge(context),
            ],
          ],
        ),
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

  Widget currentBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: ShapeDecoration(
        color: context.appTheme.successBackgroundColor,
        shape: StadiumBorder(
          side: BorderSide(color: context.appTheme.successColor),
        ),
      ),
      child: Text(
        'Current',
        style: TextStyle(color: context.appTheme.successColor),
      ),
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
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CachedNetworkImage(
              fadeInDuration: const Duration(milliseconds: 200),
              imageUrl: champion.imageUrl,
            ),
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

class ChampionsSectionFactory {
  ChampionsSectionFactory(this.searchQuery);

  final String searchQuery;

  List<Widget> regularSections(
    CurrentChampionRotation currentRotation,
    List<ChampionRotation> nextRotations,
  ) {
    final data = [
      (
        title: formatDuration(currentRotation.duration),
        champions: filterChampions(currentRotation.regularChampions),
        current: true,
      ),
      for (var rotation in nextRotations)
        (
          title: formatDuration(rotation.duration),
          champions: filterChampions(rotation.champions),
          current: false,
        ),
    ].where((data) => data.champions.isNotEmpty);

    return [
      for (var (:title, :champions, :current) in data)
        ChampionsSection(
          title: title,
          current: current,
          champions: champions,
        ),
    ];
  }

  Widget? beginnerSection(CurrentChampionRotation currentRotation) {
    final champions = filterChampions(currentRotation.beginnerChampions);
    if (champions.isEmpty) {
      return null;
    }

    return ChampionsSection(
      title: "New players up to level ${currentRotation.beginnerMaxLevel} only",
      champions: champions,
    );
  }

  String formatDuration(ChampionRotationDuration duration) {
    final formatter = DateFormat('MMMM dd');

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
