import 'package:flutter/material.dart';

import '../../common/widgets/app_dialog.dart';

class RotationSelectionButton<T> extends StatelessWidget {
  const RotationSelectionButton({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.title,
    this.footer,
    required this.items,
    required this.child,
  });

  final T initialValue;
  final ValueChanged<T> onChanged;
  final String title;
  final Widget? footer;
  final List<AppSelectionItem<T>> items;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final result = await showModalBottomSheet<T>(
            context: context,
            builder: (context) => AppSelectionDialog(
              title: title,
              footer: footer,
              initialValue: initialValue,
              items: items,
            ),
          );
          if (result != null && result != initialValue) {
            onChanged(result);
          }
        },
        borderRadius: BorderRadius.circular(4),
        child: child,
      ),
    );
  }
}
