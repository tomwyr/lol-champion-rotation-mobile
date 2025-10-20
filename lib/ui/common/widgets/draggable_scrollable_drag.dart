import 'dart:math';

import 'package:flutter/material.dart';

import 'draggable_scrollable_dismiss.dart';

class DraggableScrollableDrag extends StatelessWidget {
  const DraggableScrollableDrag({
    super.key,
    required this.maxExtent,
    required this.minExtent,
    required this.controller,
    required this.child,
  });

  final double maxExtent;
  final double minExtent;
  final DraggableScrollableController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: (details) {
        if (!_dismissIdle(context)) return;
        final newSize = _calcDraggedSize(details);
        controller.jumpTo(newSize);
      },
      onVerticalDragEnd: (details) {
        if (!_dismissIdle(context)) return;
        controller.animateTo(
          _calcSnapSize(),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      },
      child: child,
    );
  }

  bool _dismissIdle(BuildContext context) {
    return DraggableScrollableDismissScope.of(context).isIdle;
  }

  double _calcDraggedSize(DragUpdateDetails details) {
    final deltaPixels = -details.delta.dy;
    final deltaSize = controller.pixelsToSize(deltaPixels);
    var newSize = controller.size + deltaSize;
    return max(newSize, 0);
  }

  double _calcSnapSize() {
    final size = controller.size;
    if (size <= minExtent) return minExtent;
    if (size >= maxExtent) return maxExtent;

    final midExtent = (maxExtent - minExtent) / 2;
    final closerExtent = size - midExtent > 0 ? maxExtent : minExtent;
    return closerExtent;
  }
}
