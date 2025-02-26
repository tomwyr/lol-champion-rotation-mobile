import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/model/champion.dart';
import '../common/theme.dart';

class ChampionAvailabilityDescription extends StatelessWidget {
  const ChampionAvailabilityDescription({
    super.key,
    required this.availability,
    this.style,
  });

  final ChampionDetailsAvailability availability;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? const TextStyle();

    if (availability.current) {
      return Text(
        'Available',
        style: effectiveStyle.copyWith(color: context.appTheme.availableColor),
      );
    }
    if (availability.lastAvailable case var lastAvailable?) {
      final formattedDate = DateFormat('MMM dd').format(lastAvailable);
      return Text(
        'Last available $formattedDate',
        style: effectiveStyle,
      );
    }
    return Text(
      'Unavailable',
      style: effectiveStyle.copyWith(color: context.appTheme.unavailableColor),
    );
  }
}
