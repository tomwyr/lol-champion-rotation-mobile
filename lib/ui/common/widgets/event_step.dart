import 'package:flutter/material.dart';

enum EventStepStyle { filled, outline, bullet }

class EventStep extends StatelessWidget {
  const EventStep({
    super.key,
    required this.type,
    required this.style,
    required this.height,
    this.indicatorColor,
    this.padding,
    this.onTap,
    required this.child,
  });

  final EventStepType type;
  final EventStepStyle style;
  final double height;
  final Color? indicatorColor;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox(
      height: height,
      child: Row(
        children: [
          _type(context),
          Expanded(child: this.child),
        ],
      ),
    );

    if (padding != null) {
      child = Padding(padding: padding!, child: child);
    }
    if (onTap != null) {
      child = InkWell(onTap: onTap, child: child);
    }

    return child;
  }

  Widget _type(BuildContext context) {
    return Container(
      width: 48,
      padding: const .only(right: 12),
      alignment: .center,
      child: _EventStepIndicator(
        type: type,
        style: style,
        height: height,
        circleColor: indicatorColor,
      ),
    );
  }
}

enum EventStepType {
  head,
  body,
  tail,
  single;

  factory EventStepType.from({required int index, required int length}) {
    if (length == 1) return .single;
    if (index == 0) return .head;
    if (index == length - 1) return .tail;
    return .body;
  }
}

class _EventStepIndicator extends StatelessWidget {
  const _EventStepIndicator({
    required this.type,
    required this.style,
    required this.height,
    required this.circleColor,
  });

  final EventStepType type;
  final EventStepStyle style;
  final double height;
  final Color? circleColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(0, height),
      painter: _EventStepPainter(type, style, circleColor),
    );
  }
}

class _EventStepPainter extends CustomPainter {
  _EventStepPainter(this.type, this.style, this.circleColor);

  final EventStepType type;
  final EventStepStyle style;
  final Color? circleColor;

  @override
  void paint(Canvas canvas, Size size) {
    final defaultColor = Colors.grey;
    final linkPaint = Paint()..color = defaultColor;
    final circlePaint = Paint()..color = circleColor ?? defaultColor;

    final center = size.center(.zero);
    final circleRadius = switch (style) {
      .filled => _isTopStep ? 12.0 : 8.0,
      .outline => _isTopStep ? 10.0 : 8.0,
      .bullet => _isTopStep ? 8.0 : 6.0,
    };
    const linkWidth = 3.0;
    const linkInset = 1;
    final linkHeight = (size.height - circleRadius * 2) / 2 + linkInset;

    if (_drawTopLink) {
      final topLink = Rect.fromLTWH(
        center.dx - linkWidth / 2,
        center.dy - circleRadius - linkHeight + linkInset,
        linkWidth,
        linkHeight,
      );
      canvas.drawRect(topLink, linkPaint);
    }

    if (_drawBottomLink) {
      final bottomLink = Rect.fromLTWH(
        center.dx - linkWidth / 2,
        center.dy + circleRadius - linkInset,
        linkWidth,
        linkHeight,
      );
      canvas.drawRect(bottomLink, linkPaint);
    }

    void drawOuterCircle() {
      final outerCircle = Rect.fromCircle(center: center, radius: circleRadius);
      final outerCirclePaint = Paint.from(circlePaint)
        ..style = .stroke
        ..strokeWidth = 2;
      canvas.drawOval(outerCircle, outerCirclePaint);
    }

    void drawInnerCircle() {
      final innerCircle = Rect.fromCircle(center: center, radius: circleRadius - 6);
      canvas.drawOval(innerCircle, circlePaint);
    }

    void drawFilledCircle() {
      final circle = Rect.fromCircle(center: center, radius: circleRadius);
      final filledCirclePaint = Paint.from(circlePaint);
      canvas.drawOval(circle, filledCirclePaint);
    }

    switch (style) {
      case .filled:
        drawOuterCircle();
        drawInnerCircle();

      case .outline:
        drawOuterCircle();

      case .bullet:
        drawFilledCircle();
    }
  }

  @override
  bool shouldRepaint(covariant _EventStepPainter oldDelegate) {
    return oldDelegate.type != type ||
        oldDelegate.style != style ||
        oldDelegate.circleColor != circleColor;
  }

  bool get _drawTopLink {
    return switch (type) {
      .body || .tail => true,
      .head || .single => false,
    };
  }

  bool get _drawBottomLink {
    return switch (type) {
      .body || .head => true,
      .tail || .single => false,
    };
  }

  bool get _isTopStep {
    return switch (type) {
      .head || .single => true,
      .body || .tail => false,
    };
  }
}
