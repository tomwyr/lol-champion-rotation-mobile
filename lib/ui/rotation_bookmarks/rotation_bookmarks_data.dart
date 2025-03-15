import 'package:flutter/material.dart';

import '../../core/model/rotation.dart';
import '../common/components/rotation_summary.dart';
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
        indent: 16,
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
            padding: const EdgeInsets.all(16),
            child: RotationSummaryTile(
              duration: rotation.duration,
              current: rotation.current,
              championImageUrls: rotation.championImageUrls,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        );
      },
    );
  }
}
