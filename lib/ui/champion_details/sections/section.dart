import 'package:flutter/material.dart';

class ChampionDetailsSection extends StatelessWidget {
  const ChampionDetailsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final Iterable<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(context),
        const SizedBox(height: 8),
        ...children,
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
