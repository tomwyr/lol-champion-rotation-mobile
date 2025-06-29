import 'package:copy_with_extension/copy_with_extension.dart';

import '../../model/champion.dart';
import '../../state.dart';

part 'champion_details_state.g.dart';

@CopyWith()
class ChampionDetailsData {
  ChampionDetailsData({
    required this.champion,
    this.togglingObserved = false,
  });

  final ChampionDetails champion;
  final bool togglingObserved;
}

enum ChampionDetailsEvent {
  observingFailed,
  championObserved,
  championUnobserved,
}

typedef ChampionDetailsState = DataState<ChampionDetailsData>;
