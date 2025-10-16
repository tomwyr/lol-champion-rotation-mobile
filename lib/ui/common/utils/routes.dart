import 'package:flutter/material.dart';

extension BuildContextNavigator on BuildContext {
  Future<T?> pushDefaultRoute<T extends Object?>(Widget child) {
    return Navigator.of(this).push(MaterialPageRoute(builder: (_) => child));
  }

  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }
}
