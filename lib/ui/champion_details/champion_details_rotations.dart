import 'package:flutter/material.dart';

import '../../core/model/champion.dart';
import '../common/utils/assets.dart';
import 'champion_availability_description.dart';

class ChampionDetailsRotations extends StatelessWidget {
  const ChampionDetailsRotations({
    super.key,
    required this.details,
  });

  final ChampionDetails details;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        _header(context),
        for (var availability in details.rotationsAvailability)
          _rotationAvailability(context, availability)
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Text(
      'Rotations',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w300,
          ),
    );
  }

  Widget _rotationAvailability(BuildContext context, ChampionDetailsAvailability availability) {
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
