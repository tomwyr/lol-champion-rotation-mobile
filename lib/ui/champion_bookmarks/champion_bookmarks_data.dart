import 'package:flutter/material.dart';

import '../../core/model/champion.dart';
import '../champion_details/champion_details_page.dart';
import '../common/components/champion_image.dart';
import '../common/components/rotation_badge.dart';
import '../common/utils/routes.dart';
import '../common/widgets/data_states.dart';

class ChampionBookmarksData extends StatelessWidget {
  const ChampionBookmarksData({
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
      child: champions.isEmpty ? _emptyPlaceholder() : _bookmarksList(),
    );
  }

  Widget _emptyPlaceholder() {
    return const DataInfo(
      icon: Icons.bookmark_add_outlined,
      message: "Observe your first champion to see it on the list.",
    );
  }

  Widget _bookmarksList() {
    return ListView.separated(
      itemCount: champions.length,
      separatorBuilder: (context, index) => const Divider(
        height: 0,
        thickness: 0.5,
        indent: 16,
      ),
      itemBuilder: (context, index) => _championTile(context, champions[index]),
    );
  }

  Widget _championTile(BuildContext context, ObservedChampion champion) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () {
        context.pushDefaultRoute(ChampionDetailsPage(
          champion: champion.summary,
        ));
      },
      leading: ChampionImage(url: champion.imageUrl),
      title: Row(
        children: [
          Text(
            champion.name,
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
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
