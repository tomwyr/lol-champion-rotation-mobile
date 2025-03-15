import 'package:flutter/material.dart';

import '../../core/model/rotation.dart';
import '../common/components/champion_image.dart';
import '../common/components/rotation_badge.dart';
import '../common/utils/formatters.dart';
import '../common/utils/routes.dart';
import '../common/widgets/data_states.dart';
import '../rotation_details/rotation_details_page.dart';

class RotationBookmarksData extends StatelessWidget {
  const RotationBookmarksData({
    super.key,
    required this.rotations,
    required this.onRefresh,
  });

  final List<ObservedRotation> rotations;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: rotations.isEmpty ? _emptyPlaceholder() : _bookmarksList(),
    );
  }

  Widget _emptyPlaceholder() {
    return const DataInfo(
      icon: Icons.bookmark_add_outlined,
      message: "Bookmark your first rotation to see it on the list.",
    );
  }

  Widget _bookmarksList() {
    return ListView.separated(
      itemCount: rotations.length,
      separatorBuilder: (context, index) => const Divider(
        height: 0,
        thickness: 0.5,
      ),
      itemBuilder: (context, index) {
        final rotation = rotations[index];
        return InkWell(
          onTap: () {
            context.pushDefaultRoute(RotationDetailsPage(
              rotationId: rotation.id,
            ));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(rotation.duration.formatShort()),
                if (rotation.current) ...[
                  const SizedBox(width: 8),
                  const RotationBadge(
                    type: RotationBadgeVariant.current,
                    compact: true,
                  ),
                ],
                Expanded(
                  child: SizedBox(
                    height: 24,
                    child: Stack(
                      children: [
                        for (var (index, url) in rotation.championImageUrls.reversed.indexed)
                          Positioned(
                            right: index * 12,
                            child: ChampionImage(
                              url: url,
                              shape: ChampionImageShape.circle,
                              shadow: true,
                              size: 24,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
