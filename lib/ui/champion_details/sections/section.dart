import 'package:flutter/material.dart';

class ChampionDetailsSection extends StatelessWidget {
  const ChampionDetailsSection({
    required this.title,
    super.key,
    this.headerTrailing,
    this.padding = const .symmetric(horizontal: 16),
    this.padChildren = true,
    required this.children,
  });

  final String title;
  final Widget? headerTrailing;
  final EdgeInsets padding;
  final bool padChildren;
  final Iterable<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Padding(padding: padding, child: _header(context)),
        const SizedBox(height: 8),
        for (var child in children)
          if (padChildren) Padding(padding: padding, child: child) else child,
      ],
    );
  }

  Widget _header(BuildContext context) {
    final title = Text(
      this.title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: .w300),
    );

    return Row(
      mainAxisSize: .min,
      children: [
        title,
        if (headerTrailing case var trailing?) ...[
          const SizedBox(width: 4),
          trailing,
        ],
      ],
    );
  }
}
