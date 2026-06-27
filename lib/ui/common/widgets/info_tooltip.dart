import 'package:flutter/material.dart';

import '../theme.dart';

class InfoTooltip extends StatelessWidget {
  const InfoTooltip({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      triggerMode: .tap,
      preferBelow: false,
      showDuration: Duration(seconds: 2),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: .circular(4)),
        color: context.appTheme.tooltipBackgroundColor,
      ),
      child: Padding(
        padding: .all(2),
        child: Icon(
          Icons.info_outline,
          size: 20,
          color: context.appTheme.textColorDim,
        ),
      ),
    );
  }
}
