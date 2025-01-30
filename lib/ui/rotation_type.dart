import 'package:flutter/material.dart';

import '../common/app_images.dart';
import '../core/model/rotation.dart';
import 'theme.dart';

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
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () => showPicker(context),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
              child: content(context),
            ),
          ),
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

  void showPicker(BuildContext context) async {
    final result = await showModalBottomSheet<RotationType>(
      context: context,
      builder: (context) => RotationTypeDialog(selectedValue: value),
    );

    if (result != null && result != value) {
      onChanged(result);
    }
  }
}

class RotationTypeDialog extends StatelessWidget {
  const RotationTypeDialog({
    super.key,
    this.selectedValue,
  });

  final RotationType? selectedValue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Rotation type',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 12),
            regularTypeEntry(context),
            beginnerTypeEntry(context),
          ],
        ),
      ),
    );
  }

  Widget regularTypeEntry(BuildContext context) {
    return RotationTypeTile(
      title: "Summoner's Rift",
      description: "Classic map • Bi-weekly rotation",
      iconAsset: AppImages.iconSummonersRift,
      selected: selectedValue == RotationType.regular,
      onTap: () => Navigator.of(context).pop(RotationType.regular),
    );
  }

  Widget beginnerTypeEntry(BuildContext context) {
    return RotationTypeTile(
      title: "Summoner's Rift (Beginners)",
      description: "Classic map • New players only",
      iconAsset: AppImages.iconSummonersRiftBeginner,
      selected: selectedValue == RotationType.beginner,
      onTap: () => Navigator.of(context).pop(RotationType.beginner),
    );
  }
}

class RotationTypeTile extends StatelessWidget {
  const RotationTypeTile({
    super.key,
    required this.title,
    required this.description,
    required this.iconAsset,
    required this.selected,
    this.onTap,
  });

  final String title;
  final String description;
  final String iconAsset;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget child;

    child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Image.asset(
            iconAsset,
            width: 32,
            height: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.appTheme.descriptionColor,
                      ),
                ),
              ],
            ),
          ),
          if (selected) const Icon(Icons.check),
        ],
      ),
    );

    if (onTap != null) {
      child = InkWell(onTap: onTap, child: child);
    }
    if (selected) {
      child = ColoredBox(
        color: context.appTheme.selectedBackgroundColor,
        child: child,
      );
    }

    return child;
  }
}
