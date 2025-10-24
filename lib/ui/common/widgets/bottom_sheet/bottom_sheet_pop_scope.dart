import 'package:flutter/material.dart' hide ModalBottomSheetRoute, BottomSheet;

import 'bottom_sheet.dart';

/// {@template bottom_sheet_pop_scope}
/// A widget that intercepts attempts to close a modal bottom sheet and allows
/// preventing the route from being popped.
/// {@endtemplate}
class BottomSheetPopScope extends StatelessWidget {
  /// {@macro bottom_sheet_pop_scope}
  ///
  /// Creates a [BottomSheetPopScope].
  const BottomSheetPopScope({
    super.key,
    required this.onPopInvoked,
    required this.child,
  });

  /// A callback invoked when the bottom sheet is about to close, allowing the
  /// action to be prevented.
  ///
  /// If the callback resolves to `false`, the route will remain active and the
  /// bottom sheet will expand instead of closing.
  final ValueGetter<bool> onPopInvoked;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (onPopInvoked()) {
          Navigator.pop(context);
        } else {
          _expandSheet(context);
        }
      },
      child: child,
    );
  }

  void _expandSheet(BuildContext context) {
    final bottomSheet = context.findAncestorWidgetOfExactType<BottomSheet>();
    final controller = bottomSheet?.animationController;
    if (controller == null) {
      throw FlutterError(
        "The bottom sheet's animation controller was null, presumably because "
        "BottomSheetPopScope was used outside of a ModalBottomSheetRoute.",
      );
    }
    controller.forward();
  }
}
