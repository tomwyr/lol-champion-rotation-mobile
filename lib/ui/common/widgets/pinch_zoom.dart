import 'package:flutter/material.dart';

class PinchZoom extends StatefulWidget {
  const PinchZoom({
    super.key,
    required this.progress,
    this.expandThreshold = 1.5,
    this.shrinkThreshold = 0.5,
    required this.onExpand,
    required this.onShrink,
    this.rulerBuilder,
    required this.child,
  });

  final double progress;
  final double expandThreshold;
  final double shrinkThreshold;
  final VoidCallback onExpand;
  final VoidCallback onShrink;
  final Widget Function(double value)? rulerBuilder;
  final Widget child;

  @override
  State<PinchZoom> createState() => _PinchZoomState();
}

class _PinchZoomState extends State<PinchZoom> {
  late final _PinchZoomGesture gesture;

  @override
  void initState() {
    super.initState();
    gesture =
        _PinchZoomGesture(
            expandThreshold: widget.expandThreshold,
            shrinkThreshold: widget.shrinkThreshold,
            onExpand: widget.onExpand,
            onShrink: widget.onShrink,
          )
          ..initialProgress = widget.progress
          ..addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant PinchZoom oldWidget) {
    super.didUpdateWidget(oldWidget);
    gesture.initialProgress = widget.progress;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: gesture.onScaleStart,
      onScaleEnd: gesture.onScaleEnd,
      onScaleUpdate: gesture.onScaleUpdate,
      child: Stack(
        alignment: .topCenter,
        children: [
          widget.child,
          if (widget.rulerBuilder != null)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: gesture.active
                  ? Padding(
                      padding: const .only(top: 24),
                      child: widget.rulerBuilder!(gesture.progress),
                    )
                  : const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}

class PinchZoomRuler extends StatelessWidget {
  const PinchZoomRuler({
    super.key,
    required this.value,
    required this.marksCount,
    required this.startLabel,
    required this.endLabel,
  });

  final double value;
  final int marksCount;
  final String startLabel;
  final String endLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 192,
      padding: const .fromLTRB(24, 16, 24, 8),
      decoration: const ShapeDecoration(
        shape: StadiumBorder(),
        color: Colors.black,
        shadows: [BoxShadow(blurRadius: 4, spreadRadius: 2, color: Colors.black38)],
      ),
      child: Column(
        mainAxisSize: .min,
        children: [
          Row(
            crossAxisAlignment: .start,
            mainAxisAlignment: .spaceBetween,
            children: List.generate(marksCount, _mark),
          ),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [_label(startLabel, .start), _label(endLabel, .end)],
          ),
        ],
      ),
    );
  }

  Widget _mark(int index) {
    Color? color;
    double? indent;
    if (index == 0 || index == marksCount - 1) {
      color = Colors.white;
    } else {
      color = Colors.grey;
      indent = 4;
    }

    color = _calcAnimatedColor(index, color);

    return SizedBox(
      height: 12,
      width: 1,
      child: VerticalDivider(color: color, indent: indent),
    );
  }

  Color? _calcAnimatedColor(int index, Color color) {
    final markFraction = index / (marksCount - 1);
    final markDistToValue = (value - markFraction).abs();
    final animatedValue = (1 - markDistToValue - 0.8).clamp(0, 1) * 5.0;
    return ColorTween(begin: color, end: Colors.amber).transform(animatedValue);
  }

  Widget _label(String text, _Edge edge) {
    final index = switch (edge) {
      .start => 0,
      .end => marksCount - 1,
    };
    final translation = switch (edge) {
      .start => const Offset(-0.5, 0),
      .end => const Offset(0.5, 0),
    };

    final color = _calcAnimatedColor(index, Colors.white);

    return FractionalTranslation(
      translation: translation,
      child: Text(text, style: TextStyle(color: color)),
    );
  }
}

enum _Edge { start, end }

class _PinchZoomGesture extends ChangeNotifier {
  _PinchZoomGesture({
    required this.expandThreshold,
    required this.shrinkThreshold,
    required this.onExpand,
    required this.onShrink,
  }) : _initialProgress = 0,
       _progress = 0;

  final double expandThreshold;
  final double shrinkThreshold;
  final VoidCallback onExpand;
  final VoidCallback onShrink;

  double get progress => _progress;
  bool get active => _active;

  set initialProgress(double value) {
    if (value == _initialProgress) return;
    _initialProgress = value;
    if (!_active) {
      _progress = value;
    }
  }

  double _initialProgress;
  double _progress;
  var _lastScale = 1.0;
  var _active = false;

  void onScaleStart(ScaleStartDetails details) {
    if (details.pointerCount >= 2) {
      _startGesture();
    }
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount >= 2) {
      !_active ? _startGesture() : _updateGesture(details);
    } else {
      _active ? _endGesture() : _updateGesture(details);
    }
  }

  void onScaleEnd(ScaleEndDetails details) {
    _endGesture();
  }

  void _startGesture() {
    _progress = _initialProgress;
    _active = true;
    notifyListeners();
  }

  void _endGesture() {
    _progress = _initialProgress;
    _active = false;
    notifyListeners();
  }

  void _updateGesture(ScaleUpdateDetails details) {
    _detectThreshold(details);
    _progress = _calcNewProgress(details);
    _lastScale = details.scale;
    notifyListeners();
  }

  void _detectThreshold(ScaleUpdateDetails details) {
    final (previous, current) = (_lastScale, details.scale);
    if (current >= expandThreshold && previous < expandThreshold) {
      onExpand();
    } else if (current <= shrinkThreshold && previous > shrinkThreshold) {
      onShrink();
    }
  }

  double _calcNewProgress(ScaleUpdateDetails details) {
    final delta = switch (details.scale) {
      < 1.0 => (details.scale - 1) / (1 - shrinkThreshold),
      > 1.0 => (details.scale - 1) / (expandThreshold - 1),
      _ => 0,
    };
    return (_initialProgress + delta).clamp(0, 1);
  }
}
