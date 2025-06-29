import 'package:flutter/material.dart';

import '../../core/model/rotation.dart';
import '../../core/application/rotation/rotation_state.dart';
import '../common/components/champions_list.dart';
import '../common/components/rotation_badge.dart';
import '../common/utils/formatters.dart';

class CurrentRotationList extends StatelessWidget {
  const CurrentRotationList({
    super.key,
    required this.data,
    required this.rotationType,
    required this.moreDataLoader,
  });

  final RotationData data;
  final ChampionRotationType rotationType;
  final Widget moreDataLoader;

  @override
  Widget build(BuildContext context) {
    final showDataLoader = rotationType == ChampionRotationType.regular && data.hasNextRotation;

    return SliverSafeArea(
      sliver: SliverRotationsList(
        rotations: switch (rotationType) {
          ChampionRotationType.regular => _regularRotations(data),
          ChampionRotationType.beginner => _beginnerRotations(data),
        },
        footerSliver: showDataLoader ? moreDataLoader : null,
      ),
    );
  }

  List<SliverRotationsItemData> _regularRotations(RotationData rotationData) {
    final predictedRotation = rotationData.predictedRotation;
    final rotationsOverview = rotationData.rotationsOverview;
    final nextRotations = rotationData.nextRotations;

    return [
      if (predictedRotation != null)
        SliverRotationsItemData(
          key: 'prediction',
          title: predictedRotation.duration.format(),
          champions: predictedRotation.champions,
          badge: RotationBadgeVariant.prediction,
          expandable: true,
        ),
      SliverRotationsItemData(
        key: 'regular#${rotationsOverview.id}',
        rotationId: rotationsOverview.id,
        title: rotationsOverview.duration.format(),
        champions: rotationsOverview.regularChampions,
        badge: RotationBadgeVariant.current,
      ),
      for (var rotation in nextRotations)
        SliverRotationsItemData(
          key: 'regular#${rotation.id}',
          rotationId: rotation.id,
          title: rotation.duration.format(),
          champions: rotation.champions,
        ),
    ];
  }

  List<SliverRotationsItemData> _beginnerRotations(RotationData rotationData) {
    final currentRotation = rotationData.rotationsOverview;

    return [
      SliverRotationsItemData(
        key: 'beginner',
        title: "New players up to level ${currentRotation.beginnerMaxLevel} only",
        champions: currentRotation.beginnerChampions,
      ),
    ];
  }
}
