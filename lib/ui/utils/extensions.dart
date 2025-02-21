import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  Widget get sliver => SliverToBoxAdapter(child: this);
}

extension BuildContextExtensions on BuildContext {
  Orientation get orientation {
    final Size(:width, :height) = MediaQuery.of(this).size;
    return width > height ? Orientation.landscape : Orientation.portrait;
  }
}

extension WidgetIterableExtensions on Iterable<Widget> {
  Iterable<Widget> gapped({double? vertically, double? horizontally, bool sliver = false}) sync* {
    for (var (index, element) in indexed) {
      if (index > 0) {
        Widget gap = SizedBox(
          height: vertically,
          width: horizontally,
        );
        if (sliver) {
          gap = SliverToBoxAdapter(child: gap);
        }
        yield gap;
      }
      yield element;
    }
  }
}

extension ValueNotifierExtensions<T> on ValueNotifier<T> {
  void setValue(T value) {
    this.value = value;
  }
}
