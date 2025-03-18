import 'package:intl/intl.dart';

import '../../../../core/model/rotation.dart';

extension ChampionRotationDurationFormatter on ChampionRotationDuration {
  String format() => _formatWith('MMMM dd');

  String formatShort() => _formatWith('MMM dd');

  String _formatWith(String format) {
    final formatter = DateFormat(format);

    final startText = formatter.format(start);
    final endText = formatter.format(end);

    return '$startText to $endText';
  }
}

extension DateTimeFormatter on DateTime {
  String formatShortFull() {
    final formatter = DateFormat("MMM dd ''yy");
    return formatter.format(this);
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

  String get pluralSuffix {
    return this != 1 && this != -1 ? 's' : '';
  }
}
