import 'package:flutter/material.dart';

class DraggableScrollableSheetDismiss extends StatefulWidget {
  const DraggableScrollableSheetDismiss({
    super.key,
    required this.enabled,
    required this.maxExtent,
    required this.minExtent,
    required this.controller,
    this.data = const DraggableScrollableSheetDismissData(),
    required this.child,
  });

  final bool enabled;
  final double maxExtent;
  final double minExtent;
  final DraggableScrollableController controller;
  final DraggableScrollableSheetDismissData data;
  final Widget child;

  @override
  State<DraggableScrollableSheetDismiss> createState() => _DraggableScrollableSheetDismissState();
}

class _DraggableScrollableSheetDismissState extends State<DraggableScrollableSheetDismiss> {
  var _dismissed = false;
  var _dismissInProgress = false;

  DraggableScrollableDismissController? _dismissController;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onSheetUpdate);
    _dismissController = DraggableScrollableDismissScope.maybeOf(context);
    _dismissController?._attach(this);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onSheetUpdate);
    _dismissController?._detach(this);
    super.dispose();
  }

  void _onSheetUpdate() async {
    final thresholdReached = widget.controller.size <= widget.minExtent;
    if (thresholdReached) {
      _tryDismiss();
    }
  }

  void _tryDismiss() {
    if (_dismissed || _dismissInProgress) return;

    if (widget.enabled) {
      _dismissWithConfirm();
    } else {
      _dismissWithNoConfirm();
    }
  }

  void _dismissWithConfirm() async {
    _dismissInProgress = true;
    _expandSheet();
    if (await _showConfirmDialog()) {
      _dismissed = true;
      _closeSheet();
    }
    _dismissInProgress = false;
  }

  void _dismissWithNoConfirm() {
    _dismissed = true;
    _closeSheet();
  }

  void _expandSheet() {
    widget.controller.animateTo(
      widget.maxExtent,
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

class DraggableScrollableSheetDismissData {
  const DraggableScrollableSheetDismissData({
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

  final DraggableScrollableSheetDismissData data;

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

class DraggableScrollableDismissController {
  _DraggableScrollableSheetDismissState? _attachedState;

  void dismiss() {
    _attachedState?._tryDismiss();
  }

  void _attach(_DraggableScrollableSheetDismissState state) {
    if (_attachedState != null) {
      throw FlutterError('Draggable scrollable dismiss controller is already attached.');
    }
    _attachedState = state;
  }

  void _detach(_DraggableScrollableSheetDismissState state) {
    if (_attachedState != state) {
      throw FlutterError(
        'Draggable scrollable dismiss controller is not attached to the given state.',
      );
    }
    _attachedState = null;
  }
}

class DraggableScrollableDismissScope extends StatefulWidget {
  const DraggableScrollableDismissScope({
    super.key,
    required this.child,
  });

  final Widget child;

  static DraggableScrollableDismissController? maybeOf(BuildContext context) {
    final state = context.findAncestorStateOfType<_DraggableScrollableDismissScopeState>();
    return state?._controller;
  }

  static DraggableScrollableDismissController of(BuildContext context) {
    final controller = maybeOf(context);
    if (controller == null) {
      throw FlutterError(
        'DraggableScrollableDismissScope.of() called with a context that does not contain a DraggableScrollableDismissScope.',
      );
    }
    return controller;
  }

  @override
  State<DraggableScrollableDismissScope> createState() => _DraggableScrollableDismissScopeState();
}

class _DraggableScrollableDismissScopeState extends State<DraggableScrollableDismissScope> {
  final _controller = DraggableScrollableDismissController();

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
