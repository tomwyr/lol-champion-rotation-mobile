import 'package:flutter/material.dart';

import '../../../core/model/rotation.dart';
import '../theme.dart';
import '../utils/formatters.dart';
import 'champion_image.dart';

class RotationSummaryTile extends StatelessWidget {
  const RotationSummaryTile({
    super.key,
    required this.duration,
    required this.current,
    required this.championImageUrls,
    this.style,
  });

  final ChampionRotationDuration duration;
  final bool current;
  final List<String> championImageUrls;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    var effectiveStyle = style ?? DefaultTextStyle.of(context).style;
    if (current) {
      effectiveStyle = effectiveStyle.copyWith(
        color: context.appTheme.availableColor,
        fontWeight: .w600,
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            duration.formatShort(),
            style: effectiveStyle,
            maxLines: 1,
            overflow: .ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 24,
          width: (championImageUrls.length + 1) * 12,
          child: Stack(
            children: [
              for (var (index, url) in championImageUrls.reversed.indexed)
                Positioned(
                  right: index * 12,
                  child: ChampionImage(url: url, shape: .circle, shadow: true, size: 24),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
