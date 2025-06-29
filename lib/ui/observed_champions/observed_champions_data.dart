import 'package:flutter/material.dart';

import '../../core/model/champion.dart';
import '../champion_details/champion_details_page.dart';
import '../common/components/champion_image.dart';
import '../common/components/champion_name.dart';
import '../common/components/rotation_badge.dart';
import '../common/widgets/data_states.dart';

class ObservedChampionsData extends StatelessWidget {
  const ObservedChampionsData({
    super.key,
    required this.champions,
    required this.onRefresh,
  });

  final List<ObservedChampion> champions;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: champions.isEmpty ? _emptyPlaceholder() : _championsList(),
    );
  }

  Widget _emptyPlaceholder() {
    return const DataInfo(
      icon: Icons.visibility_outlined,
      message: "Observe a champion to see it on the list.",
    );
  }

  Widget _championsList() {
    return ListView.separated(
      itemCount: champions.length,
      separatorBuilder: (context, index) => const Divider(
        height: 0,
        thickness: 0.5,
        indent: 80,
      ),
      itemBuilder: (context, index) => ObservedChampionTile(
        champion: champions[index],
        heroDiscriminator: 'observedChampions/$index',
      ),
    );
  }
}

class ObservedChampionTile extends StatelessWidget {
  const ObservedChampionTile({
    super.key,
    required this.champion,
    required this.heroDiscriminator,
  });

  final ObservedChampion champion;
  final Object? heroDiscriminator;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: () => ChampionDetailsPage.push(
        context,
        champion: champion.summary,
        heroDiscriminator: heroDiscriminator,
      ),
      leading: ChampionImageHero(
        champion: champion.summary,
        discriminator: heroDiscriminator,
        size: 48,
      ),
      title: Row(
        children: [
          ChampionNameHero(
            champion: champion.summary,
            discriminator: heroDiscriminator,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (champion.current) ...[
            const SizedBox(width: 8),
            const RotationBadge(
              type: RotationBadgeVariant.current,
              compact: true,
            ),
          ],
        ],
      ),
      trailing: const Padding(
        padding: EdgeInsets.only(right: 8),
        child: Icon(Icons.chevron_right),
      ),
    );
  }
}
