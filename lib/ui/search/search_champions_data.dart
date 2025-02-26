import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/model/champion.dart';
import '../../core/model/rotation.dart';
import '../champion_details/champion_details_page.dart';
import '../common/theme.dart';
import '../common/widgets/data_states.dart';
import '../common/utils/assets.dart';
import '../common/utils/routes.dart';

class SearchChampionsData extends StatelessWidget {
  const SearchChampionsData({
    super.key,
    required this.data,
  });

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
          ChampionAvailabilityTile(
            champion: match.champion,
            availableIn: match.availableIn,
          ),
      ],
    );
  }
}

class ChampionAvailabilityTile extends StatelessWidget {
  const ChampionAvailabilityTile({
    super.key,
    required this.champion,
    required this.availableIn,
  });

  final Champion champion;
  final List<ChampionRotationType> availableIn;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushDefaultRoute(ChampionDetailsPage(
          championId: champion.id,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: SizedBox(
          height: 72,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              championAvatar(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget championAvatar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox.square(
        dimension: 72,
        child: CachedNetworkImage(imageUrl: champion.imageUrl),
      ),
    );
  }

  Widget championName(BuildContext context) {
    return Text(
      champion.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
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
      children: [
        for (var type in ChampionRotationType.values) rotationTypeStatus(type),
      ],
    );
  }

  Widget rotationTypeStatus(ChampionRotationType type) {
    return Opacity(
      opacity: availableIn.contains(type) ? 1.0 : 0.2,
      child: Image.asset(type.imageAsset, width: 22, height: 22),
    );
  }
}
