import 'dart:math';

import 'package:flutter/material.dart';

import 'draggable_scrollable_dismiss_guard.dart';

class DraggableScrollableDragForwarder extends StatelessWidget {
  const DraggableScrollableDragForwarder({
    super.key,
    required this.maxChildSize,
    required this.minChildSize,
    required this.controller,
    required this.child,
  });

  final double maxChildSize;
  final double minChildSize;
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
    return DraggableScrollableDismissGuardScope.of(context).isIdle;
  }

  double _calcDraggedSize(DragUpdateDetails details) {
    final deltaPixels = -details.delta.dy;
    final deltaSize = controller.pixelsToSize(deltaPixels);
    var newSize = controller.size + deltaSize;
    return max(newSize, 0);
  }

  double _calcSnapSize() {
    final size = controller.size;
    if (size <= minChildSize) return minChildSize;
    if (size >= maxChildSize) return maxChildSize;

    final midSize = (maxChildSize - minChildSize) / 2;
    final closerSize = size - midSize > 0 ? maxChildSize : minChildSize;
    return closerSize;
  }
}
