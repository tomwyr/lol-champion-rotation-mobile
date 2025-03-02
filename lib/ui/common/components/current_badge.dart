import 'package:flutter/material.dart';

import '../theme.dart';

class CurrentBadge extends StatelessWidget {
  const CurrentBadge({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final style = compact ? Theme.of(context).textTheme.labelMedium : const TextStyle();
    final padding = compact
        ? const EdgeInsets.symmetric(horizontal: 4, vertical: 1)
        : const EdgeInsets.symmetric(horizontal: 8, vertical: 2);

    return Container(
      padding: padding,
      decoration: ShapeDecoration(
        color: context.appTheme.availableBackgroundColor,
        shape: StadiumBorder(
          side: BorderSide(color: context.appTheme.availableColor),
        ),
      ),
      child: Text(
        'Current',
        style: style?.copyWith(color: context.appTheme.availableColor),
      ),
    );
  }
}
