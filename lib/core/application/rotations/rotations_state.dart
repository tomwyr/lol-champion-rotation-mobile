import '../../model/rotations_data.dart';
import '../../state.dart';

typedef RotationsState = DataState<RotationsData>;

enum RotationsEvent { loadingMoreDataError, loadingPredictionError, refreshFailed }
