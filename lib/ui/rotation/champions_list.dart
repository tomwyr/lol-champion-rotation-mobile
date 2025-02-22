import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../core/model/common.dart';
import '../../core/model/rotation.dart';
import '../../core/stores/app.dart';
import '../../dependencies.dart';
import '../theme.dart';
import '../utils/extensions.dart';
import '../widgets/data_states.dart';

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
    required this.compact,
  });

  final Champion champion;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        image(),
        name(context),
      ],
    );
  }

  Widget image() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: CachedNetworkImage(
          fadeInDuration: const Duration(milliseconds: 200),
          imageUrl: champion.imageUrl,
        ),
      ),
    );
  }

  Widget name(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final (style, paddingHorizontal) =
        compact ? (textTheme.bodyMedium, 8.0) : (textTheme.bodyLarge, 12.0);

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

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: 4),
        decoration: decoration,
        child: Text(
          champion.name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: style?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
