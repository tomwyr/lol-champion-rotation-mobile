import 'package:flutter/material.dart' hide showModalBottomSheet;

import '../theme.dart';
import 'bottom_sheet/bottom_sheet.dart';
import 'bottom_sheet/bottom_sheet_dismiss_guard.dart';

class AppBottomSheet extends StatelessWidget {
  AppBottomSheet({
    super.key,
    this.showHandle = true,
    this.confirmDismiss = false,
    this.confirmDismissData = const BottomSheetDismissGuardData(),
    this.padding = defaultPadding,
    this.header,
    Widget? child,
  }) : content = _StaticContent(child);

  AppBottomSheet.scrollable({
    super.key,
    this.showHandle = true,
    this.confirmDismiss = false,
    this.confirmDismissData = const BottomSheetDismissGuardData(),
    this.padding = defaultPadding,
    this.header,
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
  }) : content = _ScrollableContent(itemCount, itemBuilder);

  static const defaultPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 16);

  final bool showHandle;
  final bool confirmDismiss;
  final BottomSheetDismissGuardData confirmDismissData;
  final EdgeInsets padding;
  final Widget? header;
  final AppBottomSheetContent content;

  static Future<T?> show<T>({required BuildContext context, required WidgetBuilder builder}) {
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
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          SizedBox(height: padding.top),
          if (showHandle) const _SheetHandle(),
          if (header case var header?) header,
          Flexible(child: _content(deviceBottomPadding)),
          SizedBox(height: deviceBottomInset),
        ],
      ),
    );
  }

  Widget _content(double deviceBottomPadding) {
    final contentPadding = EdgeInsets.only(
      left: padding.left,
      right: padding.right,
      bottom: deviceBottomPadding + padding.bottom,
    );

    return switch (content) {
      _StaticContent(:var child) => SingleChildScrollView(padding: contentPadding, child: child),
      _ScrollableContent(:var itemCount, :var itemBuilder) => ListView.builder(
        padding: contentPadding,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    };
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(bottom: 12),
      child: Center(
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
      ),
    );
  }
}

sealed class AppBottomSheetContent {}

class _StaticContent extends AppBottomSheetContent {
  _StaticContent(this.child);

  final Widget? child;
}

class _ScrollableContent extends AppBottomSheetContent {
  _ScrollableContent(this.itemCount, this.itemBuilder);

  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
}
