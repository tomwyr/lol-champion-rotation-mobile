import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/model/champion.dart';
import '../common/theme.dart';
import '../common/utils/assets.dart';
import '../common/utils/extensions.dart';
import '../common/widgets/sliver_collapsing_toolbar.dart';

class ChampionDetailsData extends StatefulWidget {
  const ChampionDetailsData({
    super.key,
    required this.details,
  });

  final ChampionDetails details;

  @override
  State<ChampionDetailsData> createState() => _ChampionDetailsDataState();
}

class _ChampionDetailsDataState extends State<ChampionDetailsData> {
  final overlapHandle = SliverOverlapAbsorberHandle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverOverlapAbsorber(
              handle: overlapHandle,
              sliver: _AppBar(details: widget.details),
            ),
            SliverOverlapInjector(handle: overlapHandle),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              sliver: _RotationsSection(details: widget.details).sliver,
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({required this.details});

  final ChampionDetails details;

  @override
  Widget build(BuildContext context) {
    return SliverCollapsingAppBar(
      collapsedHeight: 56,
      expandedHeight: 152,
      builder: (expansion) {
        final verticalPadding = 10 * (1 - expansion);
        final imageMargin = 48 * (1 - expansion);
        final nameMargin = 8 + 8 * expansion;

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: imageMargin),
              _image(),
              SizedBox(width: nameMargin),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _name(context, expansion),
                    Expanded(
                      child: _subtitle(context, expansion),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _image() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CachedNetworkImage(imageUrl: details.imageUrl),
    );
  }

  Widget _name(BuildContext context, double expansion) {
    final collapsedStyle = Theme.of(context).textTheme.headlineSmall;
    final expandedStyle = Theme.of(context).textTheme.headlineMedium;
    final collapsedSize = collapsedStyle?.fontSize;
    final expandedSize = expandedStyle?.fontSize;

    double? fontSize;
    if (collapsedSize != null && expandedSize != null) {
      fontSize = collapsedSize + (expandedSize - collapsedSize) * expansion;
    }

    return Text(
      details.name,
      style: expandedStyle?.copyWith(fontSize: fontSize),
    );
  }

  Widget _subtitle(BuildContext context, double expansion) {
    return Opacity(
      opacity: expansion,
      child: OverflowBox(
        alignment: Alignment.topLeft,
        maxHeight: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(),
            if (_subtitleAvailability() case var availability?) ...[
              const SizedBox(height: 4),
              _availabilityDescription(
                context,
                availability,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Text(
      details.title,
      style: const TextStyle(
        height: 0.75,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  ChampionDetailsAvailability? _subtitleAvailability() {
    final values = details.rotationsAvailability.toList();
    values.sort((lhs, rhs) {
      if (lhs.current && !rhs.current) return -1;
      if (!lhs.current && rhs.current) return 1;

      if (lhs.lastAvailable == null && rhs.lastAvailable == null) return 0;
      if (rhs.lastAvailable == null) return -1;
      if (lhs.lastAvailable == null) return 1;
      return -lhs.lastAvailable!.compareTo(rhs.lastAvailable!);
    });
    return values.firstOrNull;
  }
}

class _RotationsSection extends StatelessWidget {
  const _RotationsSection({required this.details});

  final ChampionDetails details;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        _header(context),
        for (var availability in details.rotationsAvailability)
          _rotationAvailability(context, availability)
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Text(
      'Rotations',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w300,
          ),
    );
  }

  Widget _rotationAvailability(BuildContext context, ChampionDetailsAvailability availability) {
    return Row(
      children: [
        SizedBox.square(
          dimension: 32,
          child: Image.asset(availability.rotationType.imageAsset),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              availability.rotationType.displayName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            _availabilityDescription(context, availability),
          ],
        ),
      ],
    );
  }
}

Widget _availabilityDescription(
  BuildContext context,
  ChampionDetailsAvailability availability, {
  TextStyle? style,
}) {
  style ??= const TextStyle();

  if (availability.current) {
    return Text(
      'Available',
      style: style.copyWith(color: context.appTheme.availableColor),
    );
  }
  if (availability.lastAvailable case var lastAvailable?) {
    final formattedDate = DateFormat('MMM dd').format(lastAvailable);
    return Text(
      'Last available $formattedDate',
      style: style,
    );
  }
  return Text(
    'Unavailable',
    style: style.copyWith(color: context.appTheme.unavailableColor),
  );
}
