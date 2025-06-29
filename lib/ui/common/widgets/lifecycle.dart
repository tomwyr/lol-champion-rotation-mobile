import 'package:flutter/material.dart';

class Lifecycle extends StatefulWidget {
  const Lifecycle({
    super.key,
    this.onInit,
    this.onDispose,
    required this.child,
  });

  Lifecycle.builder({
    super.key,
    this.onInit,
    this.onDispose,
    required WidgetBuilder builder,
  }) : child = Builder(builder: builder);

  final VoidCallback? onInit;
  final VoidCallback? onDispose;
  final Widget child;

  @override
  State<Lifecycle> createState() => _LifecycleState();
}

class _LifecycleState extends State<Lifecycle> {
  @override
  void initState() {
    super.initState();
    widget.onInit?.call();
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
