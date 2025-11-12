import 'package:flutter/material.dart';

import '../../core/application/rotation/rotation_state.dart';
import '../../core/model/rotation.dart';
import '../common/components/champions_list.dart';
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

  List<SliverRotationsItemData> _regularRotations(RotationData rotationData) {
    final predictedRotation = rotationData.predictedRotation;
    final rotationsOverview = rotationData.rotationsOverview;
    final nextRotations = rotationData.nextRotations;

    return [
      if (predictedRotation != null)
        SliverRotationsItemData(
          key: 'prediction',
          title: predictedRotation.duration.formatShort(),
          subtitle: predictedRotation.formatDetails(),
          champions: predictedRotation.champions,
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
