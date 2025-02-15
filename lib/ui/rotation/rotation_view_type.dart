import 'package:flutter/material.dart';

import '../../core/model/common.dart';
import '../theme.dart';
import '../widgets/app_dialog.dart';
import 'selection_button.dart';

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
      footer: const _PinchTip(),
      items: const [
        AppSelectionItem(
          value: RotationViewType.loose,
          title: "Comfort",
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

class _PinchTip extends StatelessWidget {
  const _PinchTip();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 16,
            color: context.appTheme.descriptionColor,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              'Tip: You can also pinch the list to change the view type.',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: context.appTheme.descriptionColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
