import 'package:flutter/material.dart';

import '../widgets/app_dialog.dart';

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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => RotationViewTypeDialog.show(
          context,
          initialValue: value,
          onChanged: onChanged,
        ),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: content(),
        ),
      ),
    );
  }

  Widget content() {
    return Row(
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
    );
  }
}

class RotationViewTypeDialog extends StatelessWidget {
  const RotationViewTypeDialog({
    super.key,
    this.initialValue,
  });

  final RotationViewType? initialValue;

  static Future<void> show(
    BuildContext context, {
    required RotationViewType initialValue,
    required ValueChanged<RotationViewType> onChanged,
  }) async {
    final result = await showModalBottomSheet<RotationViewType>(
      context: context,
      builder: (context) => RotationViewTypeDialog(initialValue: initialValue),
    );
    if (result != null && result != initialValue) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppSelectionDialog(
      title: 'Rotation view type',
      initialValue: initialValue,
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
    );
  }
}
