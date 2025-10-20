import 'package:flutter/material.dart';

class DraggableScrollableDismissGuard extends StatefulWidget {
  const DraggableScrollableDismissGuard({
    super.key,
    required this.enabled,
    required this.maxChildSize,
    required this.minChildSize,
    required this.controller,
    required this.data,
    required this.child,
  });

  final bool enabled;
  final double maxChildSize;
  final double minChildSize;
  final DraggableScrollableController controller;
  final DraggableScrollableDismissGuardData data;
  final Widget child;

  @override
  State<DraggableScrollableDismissGuard> createState() => _DraggableScrollableDismissGuardState();
}

class _DraggableScrollableDismissGuardState extends State<DraggableScrollableDismissGuard> {
  var _dismissed = false;
  var _dismissPending = false;

  DraggableScrollableDismissGuardController? _dismissController;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onSheetUpdate);
    _dismissController = DraggableScrollableDismissGuardScope.maybeOf(context);
    _dismissController?._attach(this);
  }

  @override
  void didUpdateWidget(DraggableScrollableDismissGuard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onSheetUpdate);
      widget.controller.addListener(_onSheetUpdate);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onSheetUpdate);
    _dismissController?._detach(this);
    super.dispose();
  }

  void _onSheetUpdate() async {
    final thresholdReached = widget.controller.size <= widget.minChildSize;
    if (thresholdReached) {
      _tryDismiss();
    }
  }

  void _tryDismiss() {
    if (_dismissed || _dismissPending) return;

    if (widget.enabled) {
      _dismissWithConfirm();
    } else {
      _dismissWithNoConfirm();
    }
  }

  void _dismissWithConfirm() async {
    _dismissPending = true;
    _expandSheet();
    if (await _showConfirmDialog()) {
      _dismissed = true;
      _closeSheet();
    }
    _dismissPending = false;
  }

  void _dismissWithNoConfirm() {
    _dismissed = true;
    _closeSheet();
  }

  void _expandSheet() {
    widget.controller.animateTo(
      widget.maxChildSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<bool> _showConfirmDialog() async {
    final confirmed = await showDialog<bool?>(
      context: context,
      builder: (_) => _ConfirmDismissDialog(data: widget.data),
    );
    return confirmed ?? false;
  }

  void _closeSheet() {
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Configuration data for a dismiss guard in a draggable scrollable sheet.
class DraggableScrollableDismissGuardData {
  /// Creates a dismiss guard configuration providing default values for the properties.
  const DraggableScrollableDismissGuardData({
    String? title,
    String? description,
    String? confirmLabel,
    String? cancelLabel,
  })  : title = title ?? 'Confirmation',
        description = description ??
            'Are you sure you want to dismiss the sheet? Unsaved changes may be lost.',
        confirmLabel = confirmLabel ?? 'Dismiss',
        cancelLabel = cancelLabel ?? 'Cancel';

  final String title;
  final String description;
  final String confirmLabel;
  final String cancelLabel;
}

class _ConfirmDismissDialog extends StatelessWidget {
  const _ConfirmDismissDialog({required this.data});

  final DraggableScrollableDismissGuardData data;

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

class DraggableScrollableDismissGuardController {
  _DraggableScrollableDismissGuardState? _attachedState;

  bool get isIdle {
    final state = _requireState();
    return !state._dismissPending && !state._dismissed;
  }

  void dismiss() {
    _requireState()._tryDismiss();
  }

  _DraggableScrollableDismissGuardState _requireState() {
    if (_attachedState case var state?) {
      return state;
    }
    throw FlutterError('Draggable scrollable dismiss controller is not attached to any state.');
  }

  void _attach(_DraggableScrollableDismissGuardState state) {
    if (_attachedState != null) {
      throw FlutterError('Draggable scrollable dismiss controller is already attached.');
    }
    _attachedState = state;
  }

  void _detach(_DraggableScrollableDismissGuardState state) {
    if (_attachedState != state) {
      throw FlutterError(
        'Draggable scrollable dismiss controller is not attached to the given state.',
      );
    }
    _attachedState = null;
  }
}

class DraggableScrollableDismissGuardScope extends StatefulWidget {
  const DraggableScrollableDismissGuardScope({
    super.key,
    required this.child,
  });

  final Widget child;

  static DraggableScrollableDismissGuardController? maybeOf(BuildContext context) {
    final state = context.findAncestorStateOfType<_DraggableScrollableDismissGuardScopeState>();
    return state?._controller;
  }

  static DraggableScrollableDismissGuardController of(BuildContext context) {
    final controller = maybeOf(context);
    if (controller == null) {
      throw FlutterError(
        'DraggableScrollableDismissScope.of() called with a context that does not contain a DraggableScrollableDismissScope.',
      );
    }
    return controller;
  }

  @override
  State<DraggableScrollableDismissGuardScope> createState() =>
      _DraggableScrollableDismissGuardScopeState();
}

class _DraggableScrollableDismissGuardScopeState
    extends State<DraggableScrollableDismissGuardScope> {
  final _controller = DraggableScrollableDismissGuardController();

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
