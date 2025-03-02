import 'package:flutter/material.dart';

import '../../../core/model/champion.dart';
import '../../common/utils/assets.dart';
import '../../common/utils/extensions.dart';
import '../widgets/availability_description.dart';
import 'section.dart';

class ChampionDetailsRotationsSection extends StatelessWidget {
  const ChampionDetailsRotationsSection({
    super.key,
    required this.details,
  });

  final ChampionDetails details;

  @override
  Widget build(BuildContext context) {
    return ChampionDetailsSection(
      title: 'Rotations',
      children: details.availability.map(_rotationAvailability).gapped(vertically: 8),
    );
  }

  Widget _rotationAvailability(ChampionDetailsAvailability availability) {
    return Row(
      children: [
        SizedBox.square(
          dimension: 32,
          child: Image.asset(availability.rotationType.imageAsset),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              availability.rotationType.displayName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            ChampionAvailabilityDescription(availability: availability),
          ],
        ),
      ],
    );
  }
}
