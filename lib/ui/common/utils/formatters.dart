import 'package:intl/intl.dart';

import '../../../../core/model/rotation.dart';
import '../../../core/model/champion.dart';

extension ChampionRotationDurationFormatter on ChampionRotationDuration {
  String format() => _formatWith('MMMM dd');

  String formatShort() => _formatWith('MMM dd');

  String _formatWith(String baseFormat) {
    final singleYear = start.year == end.year;
    final startFormat = singleYear ? baseFormat : "$baseFormat ''yy";
    final endFormat = "$baseFormat ''yy";

    final startText = DateFormat(startFormat).format(start);
    final endText = DateFormat(endFormat).format(end);

    return '$startText to $endText';
  }
}

extension ChampionRotationDetailsFormatter on ChampionRotationDetails {
  String formatDetails() {
    return _formatRotationDetails(champions);
  }
}

extension ChampionRotationPredictionFormatter on ChampionRotationPrediction {
  String formatDetails() {
    return _formatRotationDetails(champions);
  }
}

extension ChampionRotationsOverviewFormatter on ChampionRotationsOverview {
  String formatDetails() {
    return _formatRotationDetails(regularChampions);
  }
}

extension ChampionRotationFormatter on ChampionRotation {
  String formatDetails() {
    return _formatRotationDetails(champions);
  }
}

String _formatRotationDetails(List<Champion> champions) {
  final count = champions.length;
  return ['$count champion${count.pluralSuffix} total'].join(' · ');
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
