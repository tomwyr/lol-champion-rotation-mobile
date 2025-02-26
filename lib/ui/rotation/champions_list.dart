import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../core/model/champion.dart';
import '../../core/model/common.dart';
import '../../core/stores/app.dart';
import '../../dependencies/locate.dart';
import '../champion_details/champion_details_page.dart';
import '../common/champion/champion_image.dart';
import '../common/champion/champion_name.dart';
import '../common/theme.dart';
import '../common/utils/extensions.dart';
import '../common/utils/routes.dart';
import '../common/widgets/data_states.dart';

class ChampionsList extends StatelessWidget {
  const ChampionsList({
    super.key,
    required this.rotations,
    this.headerSliver,
    this.footerSliver,
    required this.placeholder,
  });

  final List<ChampionsListRotationData> rotations;
  final Widget? headerSliver;
  final Widget? footerSliver;
  final String placeholder;

  AppStore get appStore => locate();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appStore.rotationViewType,
      builder: (context, value, child) {
        final compact = value == RotationViewType.compact;

        final sections = [
          for (var rotation in rotations)
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 12),
              sliver: ChampionsListRotation(
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
    return SliverFillRemaining(
      hasScrollBody: false,
      child: DataInfo(
        icon: Icons.search_off,
        message: placeholder,
      ),
    );
  }
}

typedef ChampionsListRotationData = ({
  String title,
  List<Champion> champions,
  bool current,
});

class ChampionsListRotation extends StatelessWidget {
  const ChampionsListRotation({
    super.key,
    required this.title,
    this.current = false,
    required this.compact,
    required this.champions,
  });

  final String title;
  final bool current;
  final bool compact;
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
          Orientation.portrait => compact ? 3 : 2,
          Orientation.landscape => compact ? 5 : 4,
        },
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: champions.length,
      itemBuilder: (context, index) => ChampionTile(
        champion: champions[index],
        compact: compact,
      ),
    );
  }

  Widget currentBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: ShapeDecoration(
        color: context.appTheme.availableBackgroundColor,
        shape: StadiumBorder(
          side: BorderSide(color: context.appTheme.availableColor),
        ),
      ),
      child: Text(
        'Current',
        style: TextStyle(color: context.appTheme.availableColor),
      ),
    );
  }
}

class ChampionTile extends StatelessWidget {
  const ChampionTile({
    super.key,
    required this.champion,
    required this.compact,
  });

  final Champion champion;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushDefaultRoute(ChampionDetailsPage(
          champion: champion,
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
      child: ChampionImageHero(champion: champion),
    );
  }

  Widget name(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = compact ? textTheme.bodyMedium : textTheme.bodyLarge;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ChampionNameHero(
        champion: champion,
        decoration: ChampionNameDecoration.badge,
        style: style?.copyWith(color: Colors.white),
        compact: compact,
      ),
    );
  }
}
