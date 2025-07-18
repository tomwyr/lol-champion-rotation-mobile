import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../../core/application/local_settings/local_settings_cubit.dart';
import '../../../core/model/champion.dart';
import '../../../core/model/common.dart';
import '../../../core/model/rotation.dart';
import '../../champion_details/champion_details_page.dart';
import '../../rotation_details/rotation_details_page.dart';
import '../utils/extensions.dart';
import '../utils/formatters.dart';
import '../widgets/data_states.dart';
import '../widgets/sliver_clip_overlap.dart';
import '../widgets/sliver_ink_well.dart';
import 'champion_image.dart';
import 'champion_name.dart';
import 'rotation_badge.dart';

class RotationSection extends StatelessWidget {
  const RotationSection({
    super.key,
    required this.rotation,
    required this.compact,
  });

  final ChampionRotationDetails rotation;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          RotationHeader(
            title: rotation.duration.format(),
            badge: rotation.current ? RotationBadgeVariant.current : null,
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
        champion: rotation.champions[index].summary,
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

  @override
  Widget build(BuildContext context) {
    final rotationViewType =
        context.select((LocalSettingsCubit cubit) => cubit.state.settings.rotationViewType);
    final compact = rotationViewType == RotationViewType.compact;

    final sections = [
      for (var (index, item) in rotations.indexed)
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 4),
          sliver: SliverRotationSection(
            key: ValueKey(item.key),
            rotationId: item.rotationId,
            sectionIndex: index,
            compact: compact,
            title: item.title,
            badge: item.badge,
            expandable: item.expandable,
            champions: item.champions,
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

class SliverRotationsItemData {
  SliverRotationsItemData({
    required this.key,
    this.rotationId,
    required this.title,
    required this.champions,
    this.badge,
    this.expandable = false,
  });

  final String key;
  final String? rotationId;
  final String title;
  final List<Champion> champions;
  final RotationBadgeVariant? badge;
  final bool expandable;
}

class SliverRotationSection extends StatefulWidget {
  const SliverRotationSection({
    super.key,
    required this.rotationId,
    required this.sectionIndex,
    required this.title,
    required this.badge,
    required this.compact,
    required this.expandable,
    required this.champions,
  });

  final String? rotationId;
  final int sectionIndex;
  final String title;
  final RotationBadgeVariant? badge;
  final bool compact;
  final bool expandable;
  final List<Champion> champions;

  @override
  State<SliverRotationSection> createState() => _SliverRotationSectionState();
}

class _SliverRotationSectionState extends State<SliverRotationSection> {
  LocalSettingsCubit get localSettingsCubit => context.read();

  var _expanded = true;

  @override
  void initState() {
    super.initState();
    if (widget.expandable) {
      _expanded = localSettingsCubit.state.settings.predictionsExpanded;
    }
  }

  void _toggleExpansion() {
    setState(() {
      _expanded = !_expanded;
    });
    localSettingsCubit.changePredictionsExpanded(_expanded);
  }

  void _showRotationDetails() {
    RotationDetailsPage.push(context, rotationId: widget.rotationId!);
  }

  @override
  Widget build(BuildContext context) {
    return SliverInkWell(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      borderRadius: BorderRadius.circular(4),
      onTap: widget.rotationId != null ? _showRotationDetails : null,
      sliver: SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverStickyHeader(
          header: RotationHeader(
            title: widget.title,
            badge: widget.badge,
            expanded: widget.expandable ? _expanded : null,
            onExpand: widget.expandable ? _toggleExpansion : null,
          ),
          sliver: _expanded ? championsGrid(context) : null,
        ),
      ),
    );
  }

  Widget championsGrid(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      sliver: SliverClipOverlap(
        sliver: SliverGrid.builder(
          gridDelegate: ChampionsGridDelegate(context.orientation, widget.compact),
          itemCount: widget.champions.length,
          itemBuilder: (context, index) => ChampionTile(
            champion: widget.champions[index].summary,
            heroDiscriminator: 'rotationSection/${widget.sectionIndex}',
            compact: widget.compact,
          ),
        ),
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

  final ChampionSummary champion;
  final Object? heroDiscriminator;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ChampionDetailsPage.push(context, champion: champion),
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
    this.badge,
    this.expanded,
    this.onExpand,
  });

  final String title;
  final RotationBadgeVariant? badge;
  final bool? expanded;
  final VoidCallback? onExpand;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Center(
        child: Row(
          textBaseline: TextBaseline.alphabetic,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Expanded(
              child: IgnorePointer(
                child: _content(context),
              ),
            ),
            if (expanded case var expanded?) ...[
              _ToggleExpansionIcon(
                expanded: expanded,
                onTap: onExpand,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w300,
                ),
          ),
        ),
        if (badge case var badge?) ...[
          const SizedBox(width: 12),
          RotationBadge(type: badge),
        ],
      ],
    );
  }
}

class _ToggleExpansionIcon extends StatelessWidget {
  const _ToggleExpansionIcon({
    required this.expanded,
    this.onTap,
  });

  final bool expanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text.rich(WidgetSpan(
          baseline: TextBaseline.alphabetic,
          alignment: PlaceholderAlignment.middle,
          child: Icon(
            expanded ? Icons.unfold_less : Icons.unfold_more,
            size: 16,
          ),
        )),
      ),
    );
  }
}
