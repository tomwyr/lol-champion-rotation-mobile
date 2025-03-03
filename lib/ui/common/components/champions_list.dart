import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../../core/model/champion.dart';
import '../../../core/model/common.dart';
import '../../../core/model/rotation.dart';
import '../../../core/stores/app.dart';
import '../../../dependencies/locate.dart';
import '../../champion_details/champion_details_page.dart';
import '../utils/extensions.dart';
import '../utils/formatters.dart';
import '../utils/routes.dart';
import '../widgets/data_states.dart';
import 'champion_image.dart';
import 'champion_name.dart';
import 'current_badge.dart';

class RotationSection extends StatelessWidget {
  const RotationSection({
    super.key,
    required this.rotation,
    required this.compact,
  });

  final ChampionRotation rotation;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          RotationHeader(
            title: rotation.duration.format(),
            current: rotation.current,
          ),
          Expanded(
            child: championsGrid(context),
          ),
        ],
      ),
    );
  }

  Widget championsGrid(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 12),
      gridDelegate: ChampionsGridDelegate(context.orientation, compact),
      itemCount: rotation.champions.length,
      itemBuilder: (context, index) => ChampionTile(
        champion: rotation.champions[index],
        compact: compact,
      ),
    );
  }
}

class SliverRotationsList extends StatelessWidget {
  const SliverRotationsList({
    super.key,
    required this.rotations,
    this.headerSliver,
    this.footerSliver,
  });

  final List<SliverRotationsItemData> rotations;
  final Widget? headerSliver;
  final Widget? footerSliver;

  AppStore get appStore => locate();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appStore.rotationViewType,
      builder: (context, value, child) {
        final compact = value == RotationViewType.compact;

        final sections = [
          for (var (index, rotation) in rotations.indexed)
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 12),
              sliver: SliverRotationSection(
                sectionIndex: index,
                compact: compact,
                title: rotation.title,
                current: rotation.current,
                champions: rotation.champions,
              ),
            ),
        ];

        return SliverMainAxisGroup(
          slivers: [
            if (headerSliver case var header?) header,
            if (sections.isNotEmpty) ...sections else emptyPlaceholder(context),
            if (footerSliver case var footer?) footer,
          ],
        );
      },
    );
  }

  Widget emptyPlaceholder(BuildContext context) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: DataInfo(
        icon: Icons.search_off,
        message: "No data is currently available.",
      ),
    );
  }
}

typedef SliverRotationsItemData = ({
  String title,
  List<Champion> champions,
  bool current,
});

class SliverRotationSection extends StatelessWidget {
  const SliverRotationSection({
    super.key,
    required this.sectionIndex,
    required this.title,
    this.current = false,
    required this.compact,
    required this.champions,
  });

  final int sectionIndex;
  final String title;
  final bool current;
  final bool compact;
  final List<Champion> champions;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverStickyHeader(
        header: RotationHeader(title: title, current: current),
        sliver: championsGrid(context),
      ),
    );
  }

  Widget championsGrid(BuildContext context) {
    return SliverGrid.builder(
      gridDelegate: ChampionsGridDelegate(context.orientation, compact),
      itemCount: champions.length,
      itemBuilder: (context, index) => ChampionTile(
        champion: champions[index],
        heroDiscriminator: sectionIndex,
        compact: compact,
      ),
    );
  }
}

class ChampionTile extends StatelessWidget {
  const ChampionTile({
    super.key,
    required this.champion,
    this.heroDiscriminator,
    required this.compact,
  });

  final Champion champion;
  final Object? heroDiscriminator;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushDefaultRoute(ChampionDetailsPage(
          champion: champion,
          heroDiscriminator: heroDiscriminator,
        ));
      },
      child: Stack(
        children: [
          image(),
          name(context),
        ],
      ),
    );
  }

  Widget image() {
    return Center(
      child: ChampionImageHero(
        champion: champion,
        discriminator: heroDiscriminator,
      ),
    );
  }

  Widget name(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = compact ? textTheme.bodyMedium : textTheme.bodyLarge;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ChampionNameHero(
        champion: champion,
        discriminator: heroDiscriminator,
        decoration: ChampionNameDecoration.badge,
        style: style?.copyWith(color: Colors.white),
        compact: compact,
      ),
    );
  }
}

class ChampionsGridDelegate extends SliverGridDelegateWithFixedCrossAxisCount {
  ChampionsGridDelegate(Orientation orientation, bool compact)
      : super(
          crossAxisCount: switch ((orientation, compact)) {
            (Orientation.portrait, true) => 3,
            (Orientation.portrait, false) => 2,
            (Orientation.landscape, true) => 5,
            (Orientation.landscape, false) => 4,
          },
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        );
}

class RotationHeader extends StatelessWidget {
  const RotationHeader({
    super.key,
    required this.title,
    required this.current,
  });

  final String title;
  final bool current;

  @override
  Widget build(BuildContext context) {
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
              const CurrentBadge(),
            ],
          ],
        ),
      ),
    );
  }
}
