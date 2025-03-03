import 'package:flutter/material.dart';

class ChampionDetailsSection extends StatelessWidget {
  const ChampionDetailsSection({
    required this.title,
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.padChildren = true,
    required this.children,
  });

  final String title;
  final EdgeInsets padding;
  final bool padChildren;
  final Iterable<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding,
          child: _header(context),
        ),
        const SizedBox(height: 8),
        for (var child in children)
          if (padChildren)
            Padding(
              padding: padding,
              child: child,
            )
          else
            child,
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w300,
          ),
    );
  }
}
