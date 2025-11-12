import 'package:flutter/material.dart';

import '../theme.dart';

class ListSectionHeader extends StatelessWidget {
  const ListSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .fromLTRB(24, 4, 24, 0),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class ListEntry extends StatelessWidget {
  const ListEntry({super.key, required this.title, this.description, this.trailing, this.onTap});

  final String title;
  final String? description;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: .start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        if (description case var description?) ...[
          const SizedBox(height: 2),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: context.appTheme.descriptionColor),
          ),
        ],
      ],
    );

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const .symmetric(horizontal: 24, vertical: 8),
        child: Row(
          crossAxisAlignment: .start,
          children: [
            Expanded(child: content),
            if (trailing != null) ...[const SizedBox(width: 12), trailing!],
          ],
        ),
      ),
    );
  }
}
