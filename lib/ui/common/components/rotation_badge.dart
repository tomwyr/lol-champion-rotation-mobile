import 'package:flutter/material.dart';

import '../theme.dart';

enum RotationBadgeVariant {
  current,
  prediction,
}

class RotationBadge extends StatelessWidget {
  const RotationBadge({
    super.key,
    required this.type,
    this.compact = false,
  });

  final RotationBadgeVariant type;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final (title, color, backgroundColor) = switch (type) {
      RotationBadgeVariant.current => (
          'Current',
          context.appTheme.availableColor,
          context.appTheme.availableBackgroundColor,
        ),
      RotationBadgeVariant.prediction => (
          'Prediction',
          context.appTheme.predictionColor,
          context.appTheme.predictionBackgroundColor,
        ),
    };

    final style = compact ? Theme.of(context).textTheme.labelMedium : const TextStyle();
    final padding = compact
        ? const EdgeInsets.symmetric(horizontal: 4, vertical: 1)
        : const EdgeInsets.symmetric(horizontal: 8, vertical: 2);

    return Container(
      padding: padding,
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: StadiumBorder(
          side: BorderSide(color: color),
        ),
      ),
      child: Text(
        title,
        style: style?.copyWith(color: color),
      ),
    );
  }
}
