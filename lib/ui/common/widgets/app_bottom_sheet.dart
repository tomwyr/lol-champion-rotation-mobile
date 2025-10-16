import 'package:flutter/material.dart';

import '../theme.dart';
import 'fit_viewport_scroll_view.dart';

class AppBottomSheet extends StatefulWidget {
  const AppBottomSheet({
    super.key,
    this.showHandle = true,
    required this.child,
  });

  final bool showHandle;
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
      builder: (context) => AppBottomSheet(
        child: builder(context),
      ),
    );
  }

  @override
  State<AppBottomSheet> createState() => _AppBottomSheetState();
}

class _AppBottomSheetState extends State<AppBottomSheet> {
  final _controller = DraggableScrollableController();

  var _minExtent = 0.0;
  var _maxExtent = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maxExtent = switch (MediaQuery.orientationOf(context)) {
      Orientation.portrait => 0.6,
      Orientation.landscape => 0.8,
    };
    _minExtent = 0;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: _maxExtent,
      maxChildSize: _maxExtent,
      minChildSize: _minExtent,
      controller: _controller,
      snap: true,
      expand: false,
      shouldCloseOnMinExtent: true,
      builder: (context, scrollController) => _content(scrollController),
    );
  }

  Widget _content(ScrollController scrollController) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: FitViewportScrollView(
          controller: scrollController,
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.showHandle) ...[
                  const _Handle(),
                  const SizedBox(height: 8),
                ],
                Expanded(child: widget.child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Handle extends StatelessWidget {
  const _Handle();

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
