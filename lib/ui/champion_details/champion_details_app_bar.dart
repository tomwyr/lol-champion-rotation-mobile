import 'package:flutter/material.dart';

import '../../core/model/champion.dart';
import '../common/champion/champion_image.dart';
import '../common/champion/champion_name.dart';
import '../common/widgets/sliver_collapsing_toolbar.dart';
import 'champion_availability_description.dart';

class ChampionDetailsAppBar extends StatelessWidget {
  const ChampionDetailsAppBar({
    super.key,
    required this.champion,
    required this.details,
  });

  final Champion champion;
  final ChampionDetails? details;

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
                    if (details case var details?)
                      Expanded(
                        child: _subtitle(context, expansion, details),
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
    return ChampionImageHero(champion: champion);
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

    return ChampionNameHero(
      champion: champion,
      style: expandedStyle?.copyWith(fontSize: fontSize),
    );
  }

  Widget _subtitle(BuildContext context, double expansion, ChampionDetails details) {
    return Opacity(
      opacity: expansion,
      child: OverflowBox(
        alignment: Alignment.topLeft,
        maxHeight: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(details),
            if (_subtitleAvailability(details) case var availability?) ...[
              const SizedBox(height: 4),
              ChampionAvailabilityDescription(
                availability: availability,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _title(ChampionDetails details) {
    return Text(
      details.title,
      style: const TextStyle(
        height: 0.75,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  ChampionDetailsAvailability? _subtitleAvailability(ChampionDetails details) {
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
