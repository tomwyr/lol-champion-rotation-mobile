import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SliverClipOverlap extends SingleChildRenderObjectWidget {
  const SliverClipOverlap({
    super.key,
    required Widget sliver,
  }) : super(child: sliver);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverClipRect();
  }
}

class RenderSliverClipRect extends RenderProxySliver {
  @override
  void paint(PaintingContext context, Offset offset) {
    final clipExtent = constraints.overlap;
    final mainExtent = geometry!.paintExtent;
    final crossExtent = geometry!.crossAxisExtent ?? constraints.crossAxisExtent;
    final paintRect = switch (constraints.axis) {
      .vertical => Rect.fromLTWH(0, clipExtent, crossExtent, mainExtent),
      .horizontal => Rect.fromLTWH(clipExtent, 0, mainExtent, crossExtent),
    };
    context.pushClipRect(needsCompositing, offset, paintRect, child!.paint);
  }
}
