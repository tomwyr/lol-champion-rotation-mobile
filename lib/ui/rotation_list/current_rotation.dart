import 'package:flutter/material.dart';

import '../../core/model/rotation.dart';
import '../../core/model/rotations_data.dart';
import '../common/components/champions_list.dart';
import '../common/utils/formatters.dart';

class CurrentRotationList extends StatelessWidget {
  const CurrentRotationList({
    super.key,
    required this.data,
    required this.rotationType,
    required this.moreDataLoader,
  });

  final RotationsData data;
  final ChampionRotationType rotationType;
  final Widget moreDataLoader;

  @override
  Widget build(BuildContext context) {
    final showDataLoader = rotationType == .regular && data.hasNextRotation;

    return SliverSafeArea(
      sliver: SliverRotationsList(
        rotations: switch (rotationType) {
          .regular => _regularRotations(data),
          .beginner => _beginnerRotations(data),
        },
        footerSliver: showDataLoader ? moreDataLoader : null,
      ),
    );
  }

  List<SliverRotationsItemData> _regularRotations(RotationsData rotationsData) {
    final rotationPrediction = rotationsData.rotationPrediction;
    final rotationsOverview = rotationsData.rotationsOverview;
    final nextRotations = rotationsData.nextRotations;

    return [
      if (rotationPrediction != null)
        SliverRotationsItemData(
          key: 'prediction',
          title: rotationPrediction.duration.formatShort(),
          subtitle: rotationPrediction.formatDetails(),
          champions: rotationPrediction.champions,
          badge: .prediction,
          expandable: true,
        ),
      SliverRotationsItemData(
        key: 'regular#${rotationsOverview.id}',
        rotationId: rotationsOverview.id,
        title: rotationsOverview.duration.formatShort(),
        subtitle: rotationsOverview.formatDetails(),
        champions: rotationsOverview.regularChampions,
        badge: .current,
      ),
      for (var rotation in nextRotations)
        SliverRotationsItemData(
          key: 'regular#${rotation.id}',
          rotationId: rotation.id,
          title: rotation.duration.formatShort(),
          subtitle: rotation.formatDetails(),
          champions: rotation.champions,
        ),
    ];
  }

  List<SliverRotationsItemData> _beginnerRotations(RotationsData rotationsData) {
    final currentRotation = rotationsData.rotationsOverview;

    return [
      SliverRotationsItemData(
        key: 'beginner',
        title: "New players up to level ${currentRotation.beginnerMaxLevel} only",
        champions: currentRotation.beginnerChampions,
      ),
    ];
  }
}
