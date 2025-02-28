import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  Orientation get orientation {
    final Size(:width, :height) = MediaQuery.of(this).size;
    return width > height ? Orientation.landscape : Orientation.portrait;
  }
}

extension WidgetIterableExtensions on Iterable<Widget> {
  List<Widget> gapped({double? vertically, double? horizontally, bool sliver = false}) {
    Widget gap = SizedBox(
      height: vertically,
      width: horizontally,
    );
    if (sliver) {
      gap = SliverToBoxAdapter(child: gap);
    }

    return [
      for (var (index, element) in indexed) ...[
        if (index > 0) gap,
        element,
      ],
    ];
  }
}

extension ValueNotifierExtensions<T> on ValueNotifier<T> {
  void setValue(T value) {
    this.value = value;
  }
}

extension ColorExtension on Color {
  Color withAlphaMultipliedBy(double value) {
    return withValues(alpha: a * value);
  }
}
