import 'package:flutter/material.dart';

import '../theme.dart';

enum RotationBadgeVariant { current, prediction }

class RotationBadge extends StatelessWidget {
  const RotationBadge({super.key, required this.type, this.compact = false});

  final RotationBadgeVariant type;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final (title, color, backgroundColor) = switch (type) {
      .current => (
        'Current',
        context.appTheme.availableColor,
        context.appTheme.availableBackgroundColor,
      ),
      .prediction => (
        'Prediction',
        context.appTheme.predictionColor,
        context.appTheme.predictionBackgroundColor,
      ),
    };

    final textTheme = Theme.of(context).textTheme;
    final style = compact ? textTheme.labelMedium : textTheme.labelLarge;
    final EdgeInsets padding = compact
        ? const .symmetric(horizontal: 5, vertical: 2)
        : const .symmetric(horizontal: 8, vertical: 3);

    return Container(
      padding: padding,
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(12),
          side: BorderSide(color: color),
        ),
      ),
      child: Text(title, style: style?.copyWith(color: color)),
    );
  }
}
