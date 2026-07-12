import 'package:flutter/material.dart';

import '../theme.dart';

class InfoTooltip extends StatelessWidget {
  const InfoTooltip({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foregroundColor = switch (theme.brightness) {
      .light => AppColors.lightText,
      .dark => AppColors.text,
    };
    final borderColor = switch (theme.brightness) {
      .light => AppColors.navy800.withValues(alpha: 0.16),
      .dark => AppColors.textMuted.withValues(alpha: 0.28),
    };

    return Tooltip(
      message: message,
      triggerMode: .tap,
      preferBelow: false,
      showDuration: Duration(seconds: 2),
      constraints: const BoxConstraints(maxWidth: 240),
      padding: const .symmetric(horizontal: 12, vertical: 8),
      margin: const .symmetric(horizontal: 16),
      textStyle: theme.textTheme.bodySmall?.copyWith(
        color: foregroundColor,
        height: 1.4,
      ),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: .circular(12),
          side: BorderSide(color: borderColor),
        ),
        color: context.appTheme.tooltipBackgroundColor,
      ),
      child: SizedBox.square(
        dimension: 32,
        child: Center(
          child: Icon(
            Icons.info_outline,
            size: 20,
            color: context.appTheme.textColorDim,
          ),
        ),
      ),
    );
  }
}
