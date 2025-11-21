import 'package:flutter/material.dart';

import '../../app/app_navigator.dart';

extension BuildContextNavigator on BuildContext {
  Future<T?> pushDefaultRoute<T extends Object?>(Widget child) {
    return AppNavigator.of(this).push(MaterialPageRoute(builder: (_) => child));
  }

  Future<T?> replaceAllDefaultRoute<T extends Object?>(Widget child) {
    return AppNavigator.of(
      this,
    ).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => child), (route) => route.isFirst);
  }

  void pop<T extends Object?>([T? result]) {
    AppNavigator.of(this).pop(result);
  }
}
