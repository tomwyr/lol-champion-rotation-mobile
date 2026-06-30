import 'package:flutter/material.dart';

class EventStep extends StatelessWidget {
  const EventStep({
    super.key,
    required this.type,
    required this.style,
    required this.modifiers,
    required this.height,
    this.indicatorColor,
    this.padding,
    this.onTap,
    this.body,
  });

  final EventStepType type;
  final EventStepStyle style;
  final EventStepModifiers modifiers;
  final double height;
  final Color? indicatorColor;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox(
      height: height,
      child: Row(
        children: [
          _type(context),
          if (body case var body?) Expanded(child: body),
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
        modifiers: modifiers,
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

enum EventStepStyle {
  filled,
  outline,
  bullet,
  line,
  gap,
}

class EventStepModifiers {
  const EventStepModifiers({
    required this.shortenTopLink,
    required this.shortenBottomLink,
    required this.capTopLink,
    required this.capBottomLink,
  });

  final bool shortenTopLink;
  final bool shortenBottomLink;
  final bool capTopLink;
  final bool capBottomLink;

  static const none = EventStepModifiers(
    shortenTopLink: false,
    shortenBottomLink: false,
    capTopLink: false,
    capBottomLink: false,
  );
}

class _EventStepIndicator extends StatelessWidget {
  const _EventStepIndicator({
    required this.type,
    required this.style,
    required this.modifiers,
    required this.height,
    required this.circleColor,
  });

  final EventStepType type;
  final EventStepStyle style;
  final EventStepModifiers modifiers;
  final double height;
  final Color? circleColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(0, height),
      painter: _EventStepPainter(
        type,
        style,
        circleColor,
        modifiers.shortenTopLink,
        modifiers.shortenBottomLink,
        modifiers.capTopLink,
        modifiers.capBottomLink,
      ),
    );
  }
}

class _EventStepPainter extends CustomPainter {
  _EventStepPainter(
    this.type,
    this.style,
    this.circleColor,
    this.shortenTopLink,
    this.shortenBottomLink,
    this.capTopLink,
    this.capBottomLink,
  );

  final EventStepType type;
  final EventStepStyle style;
  final Color? circleColor;
  final bool shortenTopLink;
  final bool shortenBottomLink;
  final bool capTopLink;
  final bool capBottomLink;

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
      .line || .gap => 0.0,
    };
    const linkWidth = 3.0;
    const linkInset = 1;
    const shortenedLinkInset = 4.0;
    const gapDotRadius = 1.5;
    const capRadius = linkWidth / 2;
    final linkX = center.dx - linkWidth / 2;
    final linkHeight = (size.height - circleRadius * 2) / 2 + linkInset;

    if (_drawTopLink) {
      final topLinkY = shortenTopLink ? shortenedLinkInset : 0.0;
      final topLinkHeight = linkHeight - topLinkY;
      final topLink = Rect.fromLTWH(
        linkX,
        topLinkY,
        linkWidth,
        topLinkHeight,
      );
      canvas.drawRect(topLink, linkPaint);
      if (capTopLink) {
        canvas.drawCircle(Offset(center.dx, topLinkY), capRadius, linkPaint);
      }
    }

    if (_drawBottomLink) {
      final bottomLinkY = size.height - linkHeight;
      final bottomLinkHeight = shortenBottomLink ? linkHeight - shortenedLinkInset : linkHeight;
      final bottomLink = Rect.fromLTWH(
        linkX,
        bottomLinkY,
        linkWidth,
        bottomLinkHeight,
      );
      canvas.drawRect(bottomLink, linkPaint);
      if (capBottomLink) {
        canvas.drawCircle(
          Offset(center.dx, bottomLinkY + bottomLinkHeight),
          capRadius,
          linkPaint,
        );
      }
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

    void drawGap() {
      final dotPaint = Paint.from(linkPaint);
      const dotCount = 3;
      final totalSize = size.height + shortenedLinkInset * 2;
      final dotSpacing = totalSize / (dotCount + 1);
      final dotOffsets = Iterable.generate(
        dotCount,
        (i) => (i + 1) * dotSpacing - totalSize / 2,
      );

      for (final offset in dotOffsets) {
        canvas.drawCircle(center.translate(0, offset), gapDotRadius, dotPaint);
      }
    }

    switch (style) {
      case .filled:
        drawOuterCircle();
        drawInnerCircle();

      case .outline:
        drawOuterCircle();

      case .bullet:
        drawFilledCircle();

      case .line:
        break;

      case .gap:
        drawGap();
    }
  }

  @override
  bool shouldRepaint(covariant _EventStepPainter oldDelegate) {
    return oldDelegate.type != type ||
        oldDelegate.style != style ||
        oldDelegate.circleColor != circleColor ||
        oldDelegate.shortenTopLink != shortenTopLink ||
        oldDelegate.shortenBottomLink != shortenBottomLink ||
        oldDelegate.capTopLink != capTopLink ||
        oldDelegate.capBottomLink != capBottomLink;
  }

  bool get _drawTopLink {
    if (style == .gap) return false;
    return switch (type) {
      .body || .tail => true,
      .head || .single => false,
    };
  }

  bool get _drawBottomLink {
    if (style == .gap) return false;
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
