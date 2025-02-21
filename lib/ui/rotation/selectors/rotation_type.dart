import 'package:flutter/material.dart';

import '../../../common/app_images.dart';
import '../../../core/model/rotation.dart';
import '../../widgets/app_dialog.dart';
import 'selection_button.dart';

class RotationTypePicker extends StatelessWidget {
  const RotationTypePicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final RotationType value;
  final ValueChanged<RotationType> onChanged;

  @override
  Widget build(BuildContext context) {
    return RotationSelectionButton(
      initialValue: value,
      onChanged: onChanged,
      title: 'Rotation type',
      items: const [
        AppSelectionItem(
          value: RotationType.regular,
          title: "Summoner's Rift",
          description: "Classic map • Weekly rotation",
          iconAsset: AppImages.iconSummonersRift,
        ),
        AppSelectionItem(
          value: RotationType.beginner,
          title: "Summoner's Rift (Beginners)",
          description: "Classic map • New players only",
          iconAsset: AppImages.iconSummonersRiftBeginner,
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
                  RotationType.regular => "Summoner's Rift",
                  RotationType.beginner => "Summoner's Rift (Beginners)",
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
