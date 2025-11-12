import 'package:copy_with_extension/copy_with_extension.dart';

import '../../model/rotation.dart';
import '../../state.dart';

part 'rotation_details_state.g.dart';

@CopyWith()
class RotationDetailsData {
  RotationDetailsData({required this.rotation, this.togglingObserved = false});

  final ChampionRotationDetails rotation;
  final bool togglingObserved;
}

enum RotationDetailsEvent { observingFailed, rotationObserved, rotationUnobserved }

typedef RotationDetailsState = DataState<RotationDetailsData>;
