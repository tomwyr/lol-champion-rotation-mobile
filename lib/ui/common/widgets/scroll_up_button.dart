import 'package:flutter/material.dart';

class ScrollUpButton extends StatelessWidget {
  const ScrollUpButton({
    super.key,
    this.threshold = 1000,
    required this.controller,
    required this.child,
  });

  final double threshold;
  final ScrollController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: .expand,
      children: [
        Positioned.fill(child: child),
        Align(
          alignment: .bottomRight,
          child: ScrollThresholdBuilder(
            threshold: threshold,
            controller: controller,
            builder: (thresholdReached, child) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: thresholdReached ? child : null,
            ),
            child: _scrollButton(context),
          ),
        ),
      ],
    );
  }

  Widget _scrollButton(BuildContext context) {
    final ColorScheme(surfaceContainer: backgroundColor, onSurface: iconColor) = Theme.of(
      context,
    ).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const .all(16),
        child: GestureDetector(
          onTap: _scrollToStart,
          child: Material(
            color: backgroundColor,
            shape: const CircleBorder(),
            elevation: 4,
            child: Padding(
              padding: const .all(12),
              child: Icon(Icons.keyboard_double_arrow_up, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToStart() {
    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }
}

class ScrollThresholdBuilder extends StatefulWidget {
  const ScrollThresholdBuilder({
    super.key,
    required this.threshold,
    required this.controller,
    required this.builder,
    required this.child,
  });

  final double threshold;
  final ScrollController controller;
  final Widget Function(bool thresholdReached, Widget child) builder;
  final Widget child;

  @override
  State<ScrollThresholdBuilder> createState() => _ScrollThresholdBuilderState();
}

class _ScrollThresholdBuilderState extends State<ScrollThresholdBuilder> {
  ScrollController? _controller;

  var _thresholdReached = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller?.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final thresholdReached = _controller!.position.extentBefore >= widget.threshold;
    if (thresholdReached != _thresholdReached) {
      setState(() {
        _thresholdReached = thresholdReached;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_thresholdReached, widget.child);
  }
}
