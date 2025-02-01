import 'package:flutter/material.dart';

class MoreDataLoader extends StatefulWidget {
  const MoreDataLoader({
    super.key,
    this.extentThreshold = 128,
    required this.controller,
    required this.onLoadMore,
  });

  final double extentThreshold;
  final ScrollController controller;
  final VoidCallback onLoadMore;

  @override
  State<MoreDataLoader> createState() => _MoreDataLoaderState();
}

class _MoreDataLoaderState extends State<MoreDataLoader> {
  late ScrollController _controller;
  var _lastThresholedReached = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant MoreDataLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != _controller) {
      _controller.removeListener(_onScroll);
      _controller = widget.controller;
      _controller.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_onScroll);
  }

  void _onScroll() {
    final position = _controller.positionOrNull;
    if (position == null) return;

    final thresholdReached = position.extentAfter <= widget.extentThreshold;
    if (!_lastThresholedReached && thresholdReached) {
      widget.onLoadMore();
    }
    _lastThresholedReached = thresholdReached;
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(48),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

extension on ScrollController {
  ScrollPosition? get positionOrNull {
    if (positions case [ScrollPosition position]) {
      return position;
    }
    return null;
  }
}
