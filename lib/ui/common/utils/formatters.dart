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

extension IntFormatter on int {
  String formatOrdinal() {
    final useDefault = switch (this) {
      11 || 12 || 13 => true,
      _ => false,
    };
    final suffix = switch (this % 10) {
      1 when !useDefault => 'st',
      2 when !useDefault => 'nd',
      3 when !useDefault => 'rd',
      _ => 'th',
    };
    return toString() + suffix;
  }
}
