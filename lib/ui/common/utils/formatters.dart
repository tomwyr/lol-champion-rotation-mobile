import 'package:intl/intl.dart';

import '../../../core/model/rotation.dart';

extension ChampionRotationDurationFormatter on ChampionRotationDuration {
  String format() {
    final formatter = DateFormat('MMMM dd');

    final startText = formatter.format(start);
    final endText = formatter.format(end);

    return '$startText to $endText';
  }
}
