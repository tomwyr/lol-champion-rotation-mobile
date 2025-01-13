import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  Widget get sliver => SliverToBoxAdapter(child: this);
}
