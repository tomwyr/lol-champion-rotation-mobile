import 'package:flutter/material.dart';

enum EventStepStyle { filled, outline, bullet }

class EventStep extends StatelessWidget {
  const EventStep({
    super.key,
    required this.type,
    required this.style,
    required this.height,
    this.padding,
    this.onTap,
    required this.child,
  });

  final EventStepType type;
  final EventStepStyle style;
  final double height;
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
      child: _EventStepIndicator(type: type, style: style, height: height),
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
  const _EventStepIndicator({required this.type, required this.style, required this.height});

  final EventStepType type;
  final EventStepStyle style;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(0, height), painter: _EventStepPainter(type, style));
  }
}

class _EventStepPainter extends CustomPainter {
  _EventStepPainter(this.type, this.style);

  final EventStepType type;
  final EventStepStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey;

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
      canvas.drawRect(topLink, paint);
    }

    if (_drawBottomLink) {
      final bottomLink = Rect.fromLTWH(
        center.dx - linkWidth / 2,
        center.dy + circleRadius - linkInset,
        linkWidth,
        linkHeight,
      );
      canvas.drawRect(bottomLink, paint);
    }

    void drawOuterCircle() {
      final outerCircle = Rect.fromCircle(center: center, radius: circleRadius);
      final circlePaint = Paint.from(paint)
        ..style = .stroke
        ..strokeWidth = 2;
      canvas.drawOval(outerCircle, circlePaint);
    }

    void drawInnerCircle() {
      final innerCircle = Rect.fromCircle(center: center, radius: circleRadius - 6);
      canvas.drawOval(innerCircle, paint);
    }

    void drawFilledCircle() {
      final circle = Rect.fromCircle(center: center, radius: circleRadius);
      final circlePaint = Paint.from(paint);
      canvas.drawOval(circle, circlePaint);
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
    return oldDelegate.type != type;
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
