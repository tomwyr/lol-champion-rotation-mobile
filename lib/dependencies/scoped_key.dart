import 'package:flutter/widgets.dart';

import 'locate.dart';

class ScopedKey<T extends Object> extends InheritedWidget {
  const ScopedKey({
    super.key,
    required this.value,
    required super.child,
  });

  final Object value;

  static Object of<T extends Object>(BuildContext context) {
    final widget = context.getInheritedWidgetOfExactType<ScopedKey<T>>();
    if (widget == null) {
      throw FlutterError(
        'ScopedKey<$T> was requested with a context that does not contain a ScopedKey<$T> widget.',
      );
    }
    return widget.value;
  }

  static T locateScopedOf<T extends Object>(BuildContext context) {
    return locateScoped<T>(ScopedKey.of<T>(context));
  }

  @override
  bool updateShouldNotify(covariant ScopedKey<T> oldWidget) {
    return value != oldWidget.value;
  }
}

extension BuildContextLocate on BuildContext {
  T locateScoped<T extends Object>() => ScopedKey.locateScopedOf(this);
}
