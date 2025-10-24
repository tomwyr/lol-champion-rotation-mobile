import 'package:flutter/material.dart';

import 'bottom_sheet_pop_scope.dart';

/// {@template bottom_sheet_dismiss_guard}
/// A widget that prevents dismissal of a bottom sheet when [enabled] is true.
///
/// When a dismissal is attempted, it shows a confirmation dialog using
/// the provided [data].
/// {@endtemplate}
class BottomSheetDismissGuard extends StatelessWidget {
  /// {@macro bottom_sheet_dismiss_guard}
  ///
  /// Creates a [BottomSheetDismissGuard].
  const BottomSheetDismissGuard({
    super.key,
    required this.enabled,
    required this.data,
    required this.child,
  });

  /// Whether the dismiss guard is active.
  final bool enabled;

  /// Configuration data for the confirmation dialog shown when dismissal is attempted.
  final BottomSheetDismissGuardData data;

  /// The content of the bottom sheet.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BottomSheetPopScope(
      onPopInvoked: () => _onDismiss(context),
      child: child,
    );
  }

  bool _onDismiss(BuildContext context) {
    if (enabled) {
      _closeSheetAfterConfirm(context);
      return false;
    } else {
      return true;
    }
  }

  void _closeSheetAfterConfirm(BuildContext context) async {
    final confirmed = await _showConfirmDialog(context);
    if (confirmed && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _showConfirmDialog(BuildContext context) async {
    final confirmed = await showDialog<bool?>(
      context: context,
      builder: (_) => _ConfirmDismissDialog(data: data),
    );
    return confirmed ?? false;
  }
}

class _ConfirmDismissDialog extends StatelessWidget {
  const _ConfirmDismissDialog({required this.data});

  final BottomSheetDismissGuardData data;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(data.title),
      content: Text(data.description),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(data.cancelLabel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(data.confirmLabel),
        ),
      ],
    );
  }
}

/// Configuration data for a dismiss guard in a bottom sheet.
class BottomSheetDismissGuardData {
  /// Creates a dismiss guard configuration providing default values for the properties.
  const BottomSheetDismissGuardData({
    String? title,
    String? description,
    String? confirmLabel,
    String? cancelLabel,
  })  : title = title ?? 'Confirmation',
        description = description ??
            'Are you sure you want to dismiss the sheet? Unsaved changes may be lost.',
        confirmLabel = confirmLabel ?? 'Dismiss',
        cancelLabel = cancelLabel ?? 'Cancel';

  /// The title of the confirmation dialog.
  final String title;

  /// The message shown in the confirmation dialog.
  final String description;

  /// The label of the confirm button.
  final String confirmLabel;

  /// The label of the cancel button.
  final String cancelLabel;
}
