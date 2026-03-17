import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import 'rotation.dart';

part 'rotations_data.g.dart';

@CopyWith()
@JsonSerializable()
class RotationsData {
  RotationsData({
    required this.rotationsOverview,
    this.nextRotations = const [],
    this.rotationPrediction,
  });

  final ChampionRotationsOverview rotationsOverview;
  final List<ChampionRotation> nextRotations;
  final ChampionRotationPrediction? rotationPrediction;

  bool get hasNextRotation => nextRotationToken != null;

  String? get nextRotationToken {
    if (nextRotations case [..., var last]) {
      return last.nextRotationToken;
    } else {
      return rotationsOverview.nextRotationToken;
    }
  }

  RotationsData appendingNext(ChampionRotation nextRotation) {
    return copyWith(nextRotations: [...nextRotations, nextRotation]);
  }

  RotationsData trimmingNextRotations(int count) {
    return RotationsData(
      rotationsOverview: rotationsOverview,
      nextRotations: [...nextRotations.take(count)],
      rotationPrediction: rotationPrediction,
    );
  }

  factory RotationsData.fromJson(Map<String, dynamic> json) => _$RotationsDataFromJson(json);

  Map<String, dynamic> toJson() => _$RotationsDataToJson(this);
}
