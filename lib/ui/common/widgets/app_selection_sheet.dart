import 'package:flutter/material.dart';

import '../theme.dart';
import '../utils/extensions.dart';
import 'app_bottom_sheet.dart';

class AppSelectionSheet<T> extends StatelessWidget {
  const AppSelectionSheet({
    super.key,
    required this.title,
    this.footer,
    required this.initialValue,
    required this.items,
  });

  final String title;
  final Widget? footer;
  final T? initialValue;
  final List<AppSelectionItem<T>> items;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      padding: AppBottomSheet.defaultPadding.verticalOnly,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 12),
          for (var item in items)
            AppSelectionTile(
              title: item.title,
              description: item.description,
              iconAsset: item.iconAsset,
              selected: item.value == initialValue,
              onTap: () => Navigator.of(context).pop(item.value),
            ),
          if (footer case var footer?) footer,
        ],
      ),
    );
  }
}

class AppSelectionItem<T> {
  const AppSelectionItem({
    required this.value,
    required this.title,
    this.description,
    this.iconAsset,
  });

  final T value;
  final String title;
  final String? description;
  final String? iconAsset;
}

class AppSelectionTile extends StatelessWidget {
  const AppSelectionTile({
    super.key,
    required this.title,
    this.description,
    this.iconAsset,
    required this.selected,
    this.onTap,
  });

  final String title;
  final String? description;
  final String? iconAsset;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (description case var description?) ...[
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.appTheme.descriptionColor,
                ),
          ),
        ],
      ],
    );

    Widget child;

    child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          if (iconAsset case var iconAsset?) ...[
            Image.asset(iconAsset, width: 32, height: 32),
            const SizedBox(width: 12),
          ],
          Expanded(child: content),
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
