import '../../model/rotations_data.dart';
import '../../state.dart';

typedef RotationState = DataState<RotationsData>;

enum RotationEvent { loadingMoreDataError, loadingPredictionError, refreshFailed }
