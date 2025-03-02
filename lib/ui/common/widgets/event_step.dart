import 'package:flutter/material.dart';

class EventStep extends StatelessWidget {
  const EventStep({
    super.key,
    required this.type,
    required this.filled,
    required this.height,
    required this.child,
  });

  final EventStepType type;
  final bool filled;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          _type(context),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _type(BuildContext context) {
    return Container(
      width: 48,
      padding: const EdgeInsets.only(right: 12),
      alignment: Alignment.center,
      child: _EventStepIndicator(
        type: type,
        filled: filled,
        height: height,
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
    if (length == 1) return EventStepType.single;
    if (index == 0) return EventStepType.head;
    if (index == length - 1) return EventStepType.tail;
    return EventStepType.body;
  }
}

class _EventStepIndicator extends StatelessWidget {
  const _EventStepIndicator({
    required this.type,
    required this.filled,
    required this.height,
  });

  final EventStepType type;
  final bool filled;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(0, height),
      painter: _EventStepPainter(type, filled),
    );
  }
}

class _EventStepPainter extends CustomPainter {
  _EventStepPainter(this.type, this.filled);

  final EventStepType type;
  final bool filled;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey;

    final center = size.center(Offset.zero);
    final circleRadius = switch ((_isTopStep, filled)) {
      (true, true) => 12.0,
      (true, false) => 10.0,
      (false, _) => 8.0,
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

    final circle = Rect.fromCircle(center: center, radius: circleRadius);
    final circlePaint = Paint.from(paint)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawOval(circle, circlePaint);

    if (filled) {
      final innerCircle = Rect.fromCircle(center: center, radius: circleRadius - 6);
      canvas.drawOval(innerCircle, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _EventStepPainter oldDelegate) {
    return oldDelegate.type != type;
  }

  bool get _drawTopLink {
    return switch (type) {
      EventStepType.body || EventStepType.tail => true,
      EventStepType.head || EventStepType.single => false,
    };
  }

  bool get _drawBottomLink {
    return switch (type) {
      EventStepType.body || EventStepType.head => true,
      EventStepType.tail || EventStepType.single => false,
    };
  }

  bool get _isTopStep {
    return switch (type) {
      EventStepType.head || EventStepType.single => true,
      EventStepType.body || EventStepType.tail => false,
    };
  }
}
