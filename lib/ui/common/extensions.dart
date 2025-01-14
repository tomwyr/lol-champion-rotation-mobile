import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  Widget get sliver => SliverToBoxAdapter(child: this);
}

extension BuildContextExtensions on BuildContext {
  Orientation get orientation {
    final Size(:width, :height) = MediaQuery.of(this).size;
    return width > height ? Orientation.landscape : Orientation.portrait;
  }
}
