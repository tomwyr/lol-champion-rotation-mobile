import 'package:flutter/material.dart';

class StaticPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  StaticPersistentHeaderDelegate({required this.extent, required this.child});

  final double extent;
  final Widget child;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => extent;

  @override
  bool shouldRebuild(StaticPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.extent != extent || oldDelegate.child != child;
  }
}
