import 'package:flutter/material.dart';

import '../../core/model/champion.dart';
import '../../core/model/rotation.dart';
import '../champion_details/champion_details_page.dart';
import '../common/components/champion_image.dart';
import '../common/components/champion_name.dart';
import '../common/theme.dart';
import '../common/utils/assets.dart';
import '../common/widgets/data_states.dart';

class SearchChampionsData extends StatelessWidget {
  const SearchChampionsData({super.key, required this.data});

  final SearchChampionsResult data;

  @override
  Widget build(BuildContext context) {
    if (data.matches.isEmpty) {
      return const DataInfo(
        icon: Icons.search_off,
        message: "No champions match your search query.",
      );
    }

    return ListView(
      children: [
        for (var match in data.matches)
          ChampionAvailabilityTile(champion: match.champion, availableIn: match.availableIn),
      ],
    );
  }
}

class ChampionAvailabilityTile extends StatelessWidget {
  const ChampionAvailabilityTile({super.key, required this.champion, required this.availableIn});

  final Champion champion;
  final List<ChampionRotationType> availableIn;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ChampionDetailsPage.push(context, champion: champion.summary),
      child: Padding(
        padding: const .symmetric(vertical: 8, horizontal: 16),
        child: SizedBox(
          height: 72,
          child: Row(
            crossAxisAlignment: .center,
            children: [
              ChampionImageHero(champion: champion.summary, size: 72),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    const SizedBox(height: 12),
                    championName(context),
                    championAvailability(context),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              rotationTypesAvailability(),
              const SizedBox(width: 16),
              const Icon(Icons.chevron_right),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget championName(BuildContext context) {
    return ChampionNameHero(
      champion: champion.summary,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget championAvailability(BuildContext context) {
    return Text(
      availableIn.isNotEmpty ? 'Available' : 'Unavailable',
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: availableIn.isNotEmpty
            ? context.appTheme.availableColor
            : context.appTheme.unavailableColor,
      ),
    );
  }

  Widget rotationTypesAvailability() {
    return Row(
      spacing: 8,
      children: [for (var type in ChampionRotationType.values) rotationTypeStatus(type)],
    );
  }

  Widget rotationTypeStatus(ChampionRotationType type) {
    return Opacity(
      opacity: availableIn.contains(type) ? 1.0 : 0.2,
      child: Image.asset(type.imageAsset, width: 22, height: 22),
    );
  }
}
