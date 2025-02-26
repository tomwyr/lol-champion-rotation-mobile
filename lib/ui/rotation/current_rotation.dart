import 'package:flutter/material.dart';

import '../../core/model/rotation.dart';
import '../../core/stores/rotation.dart';
import '../common/utils/formatters.dart';
import 'champions_list.dart';

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

    return ChampionsList(
      rotations: switch (rotationType) {
        ChampionRotationType.regular => _regularRotations(data),
        ChampionRotationType.beginner => _beginnerRotations(data),
      },
      footerSliver: showDataLoader ? moreDataLoader : null,
      placeholder: "No data is currently available.",
    );
  }

  List<ChampionsListRotationData> _regularRotations(RotationData rotationData) {
    final currentRotation = rotationData.currentRotation;
    final nextRotations = rotationData.nextRotations;

    return [
      (
        title: currentRotation.duration.format(),
        champions: currentRotation.regularChampions,
        current: true,
      ),
      for (var rotation in nextRotations)
        (
          title: rotation.duration.format(),
          champions: rotation.champions,
          current: false,
        ),
    ];
  }

  List<ChampionsListRotationData> _beginnerRotations(RotationData rotationData) {
    final currentRotation = rotationData.currentRotation;

    return [
      (
        title: "New players up to level ${currentRotation.beginnerMaxLevel} only",
        champions: currentRotation.beginnerChampions,
        current: false,
      ),
    ];
  }
}
