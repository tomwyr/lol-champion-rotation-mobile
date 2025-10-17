import 'package:flutter/material.dart';

import '../theme.dart';
import 'draggable_scrollable_sheet_dismiss.dart';
import 'fit_viewport_scroll_view.dart';

class AppBottomSheet extends StatefulWidget {
  const AppBottomSheet({
    super.key,
    this.showHandle = true,
    this.confirmDismiss = false,
    this.dismissData = const DraggableScrollableSheetDismissData(),
    required this.child,
  });

  final bool showHandle;
  final bool confirmDismiss;
  final DraggableScrollableSheetDismissData dismissData;
  final Widget child;

  static void show({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      showDragHandle: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableDismissScope(
        child: _SheetContainer(
          child: builder(context),
        ),
      ),
    );
  }

  @override
  State<AppBottomSheet> createState() => _AppBottomSheetState();
}

class _AppBottomSheetState extends State<AppBottomSheet> {
  final _controller = DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    final maxExtent = switch (MediaQuery.orientationOf(context)) {
      Orientation.portrait => 0.6,
      Orientation.landscape => 0.8,
    };
    final minExtent = widget.confirmDismiss ? maxExtent / 2 : 0.0;

    return DraggableScrollableSheetDismiss(
      enabled: widget.confirmDismiss,
      data: widget.dismissData,
      maxExtent: maxExtent,
      minExtent: minExtent,
      controller: _controller,
      child: DraggableScrollableSheet(
        initialChildSize: maxExtent,
        maxChildSize: maxExtent,
        minChildSize: minExtent,
        controller: _controller,
        snap: true,
        expand: false,
        shouldCloseOnMinExtent: false,
        builder: (context, scrollController) => _content(scrollController),
      ),
    );
  }

  Widget _content(ScrollController scrollController) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        // Bottom sheet's default color.
        color: Theme.of(context).colorScheme.surfaceContainerLow,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: FitViewportScrollView(
            controller: scrollController,
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.showHandle) ...[
                    const _SheetHandle(),
                    const SizedBox(height: 8),
                  ],
                  Expanded(child: widget.child),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetContainer extends StatelessWidget {
  const _SheetContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: DraggableScrollableDismissScope.of(context).dismiss,
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

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 4,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          color: context.appTheme.bottomSheetHandleColor,
        ),
      ),
    );
  }
}
