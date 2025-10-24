import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

extension CubitExtensions<S> on Cubit<S> {
  Future<R> untilState<R extends S>() async {
    if (state case R state) {
      return state;
    }
    return await stream.firstWhere((state) => state is R) as R;
  }
}

extension EdgeInestsExtensions on EdgeInsets {
  EdgeInsets get horizontalOnly => copyWith(top: 0, bottom: 0);

  EdgeInsets get verticalOnly => copyWith(left: 0, right: 0);
}
