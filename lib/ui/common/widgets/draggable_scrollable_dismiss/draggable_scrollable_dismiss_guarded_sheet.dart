import 'package:flutter/material.dart';

import 'draggable_scrollable_dismiss_guard.dart';
import 'draggable_scrollable_drag_forwarder.dart';

/// A widget wraps [DraggableScrollableSheet] and adds a dismiss guard,
/// prompting the user for confirmation before closing when the sheet
/// is dragged to its minimum extent.
class DraggableScrollableDismissGuardedSheet extends StatefulWidget {
  /// Creates a draggable scrollable bottom sheet with optional dismiss guard.
  const DraggableScrollableDismissGuardedSheet({
    super.key,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 1.0,
    this.expand = true,
    this.snap = false,
    this.snapSizes,
    this.snapAnimationDuration,
    this.controller,
    this.shouldCloseOnMinExtent = true,
    this.dismissGuardEnabled = true,
    this.dismissGuardData = const DraggableScrollableDismissGuardData(),
    required this.builder,
  });

  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final bool expand;
  final bool snap;
  final List<double>? snapSizes;
  final Duration? snapAnimationDuration;
  final DraggableScrollableController? controller;
  final bool shouldCloseOnMinExtent;
  final bool dismissGuardEnabled;
  final DraggableScrollableDismissGuardData dismissGuardData;
  final ScrollableWidgetBuilder builder;

  @override
  State<DraggableScrollableDismissGuardedSheet> createState() =>
      _DraggableScrollableDismissGuardedSheetState();
}

class _DraggableScrollableDismissGuardedSheetState
    extends State<DraggableScrollableDismissGuardedSheet> {
  final _defaultController = DraggableScrollableController();

  DraggableScrollableController get _effectiveController {
    DraggableScrollableDismissGuardedSheet;
    DraggableScrollableDismissGuardedSheet(
      builder: (context, scrollController) => Container(),
    );
    return widget.controller ?? _defaultController;
  }

  @override
  void dispose() {
    _defaultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableDragForwarder(
      maxChildSize: widget.maxChildSize,
      minChildSize: widget.minChildSize,
      controller: _effectiveController,
      child: DraggableScrollableDismissGuard(
        enabled: widget.dismissGuardEnabled,
        data: widget.dismissGuardData,
        maxChildSize: widget.maxChildSize,
        minChildSize: widget.minChildSize,
        controller: _effectiveController,
        child: DraggableScrollableSheet(
          initialChildSize: widget.initialChildSize,
          minChildSize: widget.minChildSize,
          maxChildSize: widget.maxChildSize,
          expand: widget.expand,
          snap: widget.snap,
          snapSizes: widget.snapSizes,
          snapAnimationDuration: widget.snapAnimationDuration,
          controller: _effectiveController,
          shouldCloseOnMinExtent: widget.shouldCloseOnMinExtent,
          builder: widget.builder,
        ),
      ),
    );
  }
}
