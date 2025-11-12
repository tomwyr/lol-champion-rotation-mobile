import 'package:flutter/material.dart';

class SliverCollapsingAppBar extends StatelessWidget {
  const SliverCollapsingAppBar({
    super.key,
    required this.collapsedHeight,
    required this.expandedHeight,
    required this.builder,
  });

  final double collapsedHeight;
  final double expandedHeight;
  final Widget Function(double expansion) builder;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: collapsedHeight,
      collapsedHeight: collapsedHeight,
      expandedHeight: expandedHeight,
      pinned: true,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final expansion =
              (constraints.maxHeight - collapsedHeight) / (expandedHeight - collapsedHeight);

          return Padding(
            padding: .only(top: collapsedHeight * expansion),
            child: SizedBox(
              height: expandedHeight - collapsedHeight,
              child: builder(expansion),
            ),
          );
        },
      ),
    );
  }
}
