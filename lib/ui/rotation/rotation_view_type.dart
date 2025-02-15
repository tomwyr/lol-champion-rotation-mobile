import 'package:flutter/material.dart';

import '../widgets/app_dialog.dart';
import 'selection_button.dart';

enum RotationViewType {
  loose,
  compact,
}

class RotationViewTypePicker extends StatelessWidget {
  const RotationViewTypePicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final RotationViewType value;
  final ValueChanged<RotationViewType> onChanged;

  @override
  Widget build(BuildContext context) {
    return RotationSelectionButton(
      initialValue: value,
      onChanged: onChanged,
      title: 'Rotation view type',
      items: const [
        AppSelectionItem(
          value: RotationViewType.loose,
          title: "Loose",
          description: "2 champions per row",
        ),
        AppSelectionItem(
          value: RotationViewType.compact,
          title: "Compact",
          description: "3 champions per row",
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 2, 0, 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              size: 16,
              switch (value) {
                RotationViewType.loose => Icons.density_medium,
                RotationViewType.compact => Icons.density_small,
              },
            ),
            const Icon(Icons.keyboard_arrow_down, size: 20),
          ],
        ),
      ),
    );
  }
}
