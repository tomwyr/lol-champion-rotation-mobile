import 'dart:math';

import 'package:flutter/material.dart';

import '../theme.dart';
import '../utils/extensions.dart';
import 'draggable_scrollable_dismiss/draggable_scrollable_dismiss_guard.dart';
import 'draggable_scrollable_dismiss/draggable_scrollable_dismiss_guarded_sheet.dart';
import 'fit_viewport_scroll_view.dart';

class AppBottomSheet extends StatefulWidget {
  const AppBottomSheet({
    super.key,
    this.showHandle = true,
    this.confirmDismiss = false,
    this.maxExtent = 0.5,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.confirmDismissData = const DraggableScrollableDismissGuardData(),
    required this.child,
  });

  final bool showHandle;
  final bool confirmDismiss;
  final double maxExtent;
  final EdgeInsets padding;
  final DraggableScrollableDismissGuardData confirmDismissData;
  final Widget child;

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      showDragHandle: false,
      enableDrag: false,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      backgroundColor: Colors.transparent,
      builder: builder,
    );
  }

  @override
  State<AppBottomSheet> createState() => _AppBottomSheetState();
}

class _AppBottomSheetState extends State<AppBottomSheet> {
  final _controller = DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    final maxExtent = switch (context.orientation) {
      Orientation.portrait => widget.maxExtent,
      Orientation.landscape => min(widget.maxExtent * 2, 0.9),
    };
    final minExtent = widget.confirmDismiss ? maxExtent / 2 : 0.0;

    return DraggableScrollableDismissGuardScope(
      child: _SheetBarrier(
        child: _SheetPanel(
          padding: widget.padding,
          child: DraggableScrollableDismissGuardedSheet(
            initialChildSize: maxExtent,
            maxChildSize: maxExtent,
            minChildSize: minExtent,
            controller: _controller,
            snap: true,
            expand: false,
            shouldCloseOnMinExtent: false,
            dismissGuardEnabled: widget.confirmDismiss,
            dismissGuardData: widget.confirmDismissData,
            builder: (context, scrollController) => _content(scrollController),
          ),
        ),
      ),
    );
  }

  Widget _content(ScrollController scrollController) {
    final scrollable = Expanded(
      child: FitViewportScrollView(
        controller: scrollController,
        child: IntrinsicHeight(
          child: widget.child,
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showHandle) _SheetHandle(maxHeight: constraints.maxHeight),
          scrollable,
        ],
      ),
    );
  }
}

class _SheetBarrier extends StatelessWidget {
  const _SheetBarrier({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: DraggableScrollableDismissGuardScope.of(context).dismiss,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      ],
    );
  }
}

class _SheetPanel extends StatelessWidget {
  const _SheetPanel({
    required this.child,
    required this.padding,
  });

  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Bottom sheet's max width in Material3 spec.
      constraints: const BoxConstraints(maxWidth: 640),
      // Inset from the bottom when the keyboard is active.
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: ShapeDecoration(
        // Bottom sheet's default color.
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle({required this.maxHeight});

  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    const handleHeight = 4.0;
    const bottomPadding = 12.0;
    const totalHeight = handleHeight + bottomPadding;

    return SizedBox(
      height: min(maxHeight, totalHeight),
      child: OverflowBox(
        maxHeight: totalHeight,
        alignment: Alignment.topCenter,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 32,
            height: handleHeight,
            padding: const EdgeInsets.only(bottom: bottomPadding),
            decoration: ShapeDecoration(
              shape: const StadiumBorder(),
              color: context.appTheme.bottomSheetHandleColor,
            ),
          ),
        ),
      ),
    );
  }
}
