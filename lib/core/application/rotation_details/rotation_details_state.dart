import 'package:copy_with_extension/copy_with_extension.dart';

import '../../model/rotation.dart';
import '../../state.dart';

part 'rotation_details_state.g.dart';

@CopyWith()
class RotationDetailsData {
  RotationDetailsData({required this.rotation, this.togglingObserved = false});

  final ChampionRotationDetails rotation;
  final bool togglingObserved;

  RotationDetailsData withObserving(bool observing) {
    return copyWith(rotation: rotation.copyWith(observing: observing));
  }
}

enum RotationDetailsEvent { observingFailed, rotationObserved, rotationUnobserved, refreshFailed }

typedef RotationDetailsState = DataState<RotationDetailsData>;
