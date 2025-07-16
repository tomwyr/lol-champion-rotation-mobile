import 'package:copy_with_extension/copy_with_extension.dart';

import '../../model/rotation.dart';
import '../../state.dart';

part 'rotation_state.g.dart';

typedef RotationState = DataState<RotationData>;

@CopyWith()
class RotationData {
  RotationData({
    required this.rotationsOverview,
    this.nextRotations = const [],
    this.predictedRotation,
  });

  final ChampionRotationsOverview rotationsOverview;
  final List<ChampionRotation> nextRotations;
  final ChampionRotationPrediction? predictedRotation;

  bool get hasNextRotation => nextRotationToken != null;

  String? get nextRotationToken {
    if (nextRotations case [..., var last]) {
      return last.nextRotationToken;
    } else {
      return rotationsOverview.nextRotationToken;
    }
  }

  RotationData appendingNext(ChampionRotation nextRotation) {
    return copyWith(nextRotations: [...nextRotations, nextRotation]);
  }
}

enum RotationEvent {
  loadingMoreDataError,
  loadingPredictionError,
}
