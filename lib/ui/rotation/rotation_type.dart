import 'package:flutter/material.dart';

import '../../common/app_images.dart';
import '../../core/model/rotation.dart';
import '../theme.dart';
import '../widgets/app_dialog.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: InkWell(
        onTap: () => RotationTypeDialog.show(
          context,
          initialValue: value,
          onChanged: onChanged,
        ),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
          child: content(context),
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    return Row(
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
        Icon(
          Icons.keyboard_arrow_down,
          color: context.appTheme.iconColorDim,
        ),
      ],
    );
  }
}

class RotationTypeDialog extends StatelessWidget {
  const RotationTypeDialog({
    super.key,
    this.initialValue,
  });

  final RotationType? initialValue;

  static Future<void> show(
    BuildContext context, {
    required RotationType initialValue,
    required ValueChanged<RotationType> onChanged,
  }) async {
    final result = await showModalBottomSheet<RotationType>(
      context: context,
      builder: (context) => RotationTypeDialog(initialValue: initialValue),
    );
    if (result != null && result != initialValue) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppSelectionDialog(
      title: 'Rotation type',
      initialValue: initialValue,
      items: const [
        AppSelectionItem(
          value: RotationType.regular,
          title: "Summoner's Rift",
          description: "Classic map • Bi-weekly rotation",
          iconAsset: AppImages.iconSummonersRift,
        ),
        AppSelectionItem(
          value: RotationType.beginner,
          title: "Summoner's Rift (Beginners)",
          description: "Classic map • New players only",
          iconAsset: AppImages.iconSummonersRiftBeginner,
        ),
      ],
    );
  }
}
