import 'package:flutter/material.dart';

import '../../../core/model/common.dart';
import '../../common/theme.dart';
import '../../common/widgets/app_dialog.dart';
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
        padding: const EdgeInsets.all(8),
        child: Icon(
          size: 16,
          switch (value) {
            RotationViewType.loose => Icons.density_medium,
            RotationViewType.compact => Icons.density_small,
          },
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
