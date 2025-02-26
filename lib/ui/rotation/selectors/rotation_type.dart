import 'package:flutter/material.dart';

import '../../../core/model/rotation.dart';
import '../../common/widgets/app_dialog.dart';
import '../../common/utils/assets.dart';
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
        _item(ChampionRotationType.regular),
        _item(ChampionRotationType.beginner),
      ],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 2, 2, 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                value.displayName,
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

  AppSelectionItem<ChampionRotationType> _item(ChampionRotationType type) {
    return AppSelectionItem(
      value: type,
      title: type.displayName,
      description: type.description,
      iconAsset: type.imageAsset,
    );
  }
}
