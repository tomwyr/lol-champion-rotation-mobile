import 'package:flutter/material.dart';

class PinchZoom extends StatefulWidget {
  const PinchZoom({
    super.key,
    required this.progress,
    this.expandThreshold = 1.5,
    this.shrinkThreshold = 0.7,
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
  late final ValueNotifier<double> progress;

  var lastScale = 1.0;
  var active = false;

  @override
  void initState() {
    super.initState();
    progress = ValueNotifier(widget.progress);
  }

  @override
  void didUpdateWidget(covariant PinchZoom oldWidget) {
    super.didUpdateWidget(oldWidget);
    progress.value = widget.progress;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        progress.value = widget.progress;
        setState(() {
          active = true;
        });
      },
      onScaleEnd: (details) {
        progress.value = widget.progress;
        setState(() {
          active = false;
        });
      },
      onScaleUpdate: (details) {
        detectThreshold(details);
        progress.value = calcNewProgress(details);
        lastScale = details.scale;
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          widget.child,
          if (widget.rulerBuilder != null)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: active ? ruler() : const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }

  Widget ruler() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: ValueListenableBuilder(
        valueListenable: progress,
        builder: (context, value, child) => widget.rulerBuilder!(value),
      ),
    );
  }

  void detectThreshold(ScaleUpdateDetails details) {
    final (previous, current) = (lastScale, details.scale);
    final (expandOn, shrinkOn) = (widget.expandThreshold, widget.shrinkThreshold);
    if (current >= expandOn && previous < expandOn) {
      widget.onExpand();
    } else if (current <= shrinkOn && previous > shrinkOn) {
      widget.onShrink();
    }
  }

  double calcNewProgress(ScaleUpdateDetails details) {
    final (expandOn, shrinkOn) = (widget.expandThreshold, widget.shrinkThreshold);
    final delta = switch (details.scale) {
      < 1.0 => (details.scale - 1) / (1 - shrinkOn),
      > 1.0 => (details.scale - 1) / (expandOn - 1),
      _ => 0,
    };
    return (widget.progress + delta).clamp(0, 1);
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
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      decoration: const ShapeDecoration(
        shape: StadiumBorder(),
        color: Colors.black,
        shadows: [
          BoxShadow(
            blurRadius: 4,
            spreadRadius: 2,
            color: Colors.black38,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(marksCount, _mark),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _label(startLabel, _Edge.start),
              _label(endLabel, _Edge.end),
            ],
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
      _Edge.start => 0,
      _Edge.end => marksCount - 1,
    };
    final translation = switch (edge) {
      _Edge.start => const Offset(-0.5, 0),
      _Edge.end => const Offset(0.5, 0),
    };

    final color = _calcAnimatedColor(index, Colors.white);

    return FractionalTranslation(
      translation: translation,
      child: Text(text, style: TextStyle(color: color)),
    );
  }
}

enum _Edge { start, end }
