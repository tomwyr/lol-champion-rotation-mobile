import 'package:flutter/material.dart' hide showModalBottomSheet;

import '../theme.dart';
import '../utils/extensions.dart';
import 'bottom_sheet/bottom_sheet.dart';
import 'bottom_sheet/bottom_sheet_dismiss_guard.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    this.showHandle = true,
    this.confirmDismiss = false,
    this.confirmDismissData = const BottomSheetDismissGuardData(),
    this.padding = defaultPadding,
    required this.child,
  });

  static const defaultPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 16);

  final bool showHandle;
  final bool confirmDismiss;
  final BottomSheetDismissGuardData confirmDismissData;
  final EdgeInsets padding;
  final Widget child;

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      scrollControlDisabledMaxHeightRatio: 0.95,
      useSafeArea: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceBottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final deviceBottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BottomSheetDismissGuard(
      enabled: confirmDismiss,
      data: confirmDismissData,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: padding.top),
          if (showHandle) const _SheetHandle(),
          Flexible(
            child: SingleChildScrollView(
              padding: padding.horizontalOnly,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: child),
                  SizedBox(height: deviceBottomPadding + padding.bottom),
                ],
              ),
            ),
          ),
          SizedBox(height: deviceBottomInset),
        ],
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: 32,
        height: 4,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: context.appTheme.bottomSheetHandleColor,
          ),
        ),
      ),
    );
  }
}
