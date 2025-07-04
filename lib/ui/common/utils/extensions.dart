import 'dart:async';

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

  Future<E> untilFirst<E extends T>() async {
    if (value case E expected) {
      return expected;
    }

    final completer = Completer<E>();
    late VoidCallback listener;
    listener = () {
      if (value case E expected) {
        removeListener(listener);
        completer.complete(expected);
      }
    };
    addListener(listener);
    return completer.future;
  }
}

extension ColorExtension on Color {
  Color withAlphaMultipliedBy(double value) {
    return withValues(alpha: a * value);
  }
}

extension StreamExtensions<T> on Stream<T> {
  Future<R> firstOfType<R extends T>() async {
    return await firstWhere((event) => event is R) as R;
  }
}
