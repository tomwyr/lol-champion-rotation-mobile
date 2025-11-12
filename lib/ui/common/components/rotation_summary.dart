import 'package:flutter/material.dart';

import '../../../core/model/rotation.dart';
import '../utils/formatters.dart';
import 'champion_image.dart';
import 'rotation_badge.dart';

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
    return Row(
      children: [
        Text(
          duration.formatShort(),
          style: style,
        ),
        if (current) ...[
          const SizedBox(width: 8),
          const RotationBadge(
            type: .current,
            compact: true,
          ),
        ],
        Expanded(
          child: SizedBox(
            height: 24,
            child: Stack(
              children: [
                for (var (index, url) in championImageUrls.reversed.indexed)
                  Positioned(
                    right: index * 12,
                    child: ChampionImage(
                      url: url,
                      shape: .circle,
                      shadow: true,
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
