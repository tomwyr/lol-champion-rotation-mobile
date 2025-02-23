import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/model/rotation.dart';
import '../utils/assets.dart';
import '../widgets/data_states.dart';

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
    return ListTile(
      leading: championAvatar(),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Flexible(child: championName(context)),
          const SizedBox(width: 8),
          championAvailability(context),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          spacing: 8,
          children: [
            for (var type in ChampionRotationType.values) rotationTypeStatus(type),
          ],
        ),
      ),
    );
  }

  Widget championAvatar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox.square(
        dimension: 56,
        child: CachedNetworkImage(imageUrl: champion.imageUrl),
      ),
    );
  }

  Widget championName(BuildContext context) {
    return Text(
      champion.name,
      maxLines: 1,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget championAvailability(BuildContext context) {
    return Text(
      availableIn.isNotEmpty ? 'Available' : 'Unavailable',
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: availableIn.isNotEmpty ? Colors.green : Colors.grey,
          ),
    );
  }

  Widget rotationTypeStatus(ChampionRotationType type) {
    return Opacity(
      opacity: availableIn.contains(type) ? 1.0 : 0.2,
      child: Image.asset(type.imageAsset, width: 20, height: 20),
    );
  }
}
