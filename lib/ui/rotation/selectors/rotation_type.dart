import 'package:flutter/material.dart';

import '../../../core/model/rotation.dart';
import '../../utils/assets.dart';
import '../../widgets/app_dialog.dart';
import 'selection_button.dart';

class RotationTypePicker extends StatelessWidget {
  const RotationTypePicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ChampionRotationType value;
  final ValueChanged<ChampionRotationType> onChanged;

  @override
  Widget build(BuildContext context) {
    return RotationSelectionButton(
      initialValue: value,
      onChanged: onChanged,
      title: 'Rotation type',
      items: [
        AppSelectionItem(
          value: ChampionRotationType.regular,
          title: "Summoner's Rift",
          description: "Classic map • Weekly rotation",
          iconAsset: ChampionRotationType.regular.imageAsset,
        ),
        AppSelectionItem(
          value: ChampionRotationType.beginner,
          title: "Summoner's Rift (Beginners)",
          description: "Classic map • New players only",
          iconAsset: ChampionRotationType.beginner.imageAsset,
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 2, 2, 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                switch (value) {
                  ChampionRotationType.regular => "Summoner's Rift",
                  ChampionRotationType.beginner => "Summoner's Rift (Beginners)",
                },
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}
