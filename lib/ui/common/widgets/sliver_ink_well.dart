import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverInkWell extends MultiChildRenderObjectWidget {
  SliverInkWell({
    super.key,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
    required Widget sliver,
  }) : super(
          children: [
            sliver,
            Ink(
              padding: padding,
              child: InkWell(
                borderRadius: borderRadius,
                onTap: onTap,
              ),
            ),
          ],
        );

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverInkWell();
  }
}

class RenderSliverInkWell extends RenderSliver
    with ContainerRenderObjectMixin<RenderObject, SliverInkWellParentData>, RenderSliverHelpers {
  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! SliverInkWellParentData) {
      child.parentData = SliverInkWellParentData();
    }
  }

  RenderSliver get content => firstChild as RenderSliver;
  RenderBox get ink => lastChild as RenderBox;

  @override
  void performLayout() {
    content.layout(constraints, parentUsesSize: true);

    final contentExtent = content.geometry!.paintExtent;
    final inkConstraints = constraints.asBoxConstraints(maxExtent: contentExtent);
    ink.layout(inkConstraints, parentUsesSize: true);

    geometry = content.geometry;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    content.paint(context, offset);
    ink.paint(context, offset);
  }

  @override
  double childMainAxisPosition(covariant RenderObject child) {
    final childParentData = child.parentData! as SliverInkWellParentData;
    return childParentData.paintOffset.dx;
  }

  @override
  bool hitTestChildren(
    SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    return content.hitTest(
          result,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition,
        ) ||
        hitTestBoxChild(
          BoxHitTestResult.wrap(result),
          ink,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition,
        );
  }

  @override
  void applyPaintTransform(covariant RenderObject child, Matrix4 transform) {
    final childParentData = child.parentData! as SliverInkWellParentData;
    childParentData.applyPaintTransform(transform);
  }
}

class SliverInkWellParentData extends SliverPhysicalParentData with ContainerParentDataMixin {}
