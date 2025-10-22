import 'package:flutter/material.dart';

import '../../../core/model/common.dart';
import '../../common/theme.dart';
import '../../common/widgets/app_bottom_sheet.dart';
import '../../common/widgets/app_selection_sheet.dart';

class RotationViewTypeDialog extends StatelessWidget {
  const RotationViewTypeDialog({
    super.key,
    required this.initialValue,
  });

  final RotationViewType? initialValue;

  static Future<void> show(
    BuildContext context, {
    required RotationViewType initialValue,
    required ValueChanged<RotationViewType> onChanged,
  }) async {
    final result = await AppBottomSheet.show<RotationViewType>(
      context: context,
      builder: (context) => RotationViewTypeDialog(initialValue: initialValue),
    );
    if (result != null && result != initialValue) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppSelectionSheet(
      title: 'Rotation view type',
      footer: const _PinchTip(),
      initialValue: initialValue,
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
