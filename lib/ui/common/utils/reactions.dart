import 'dart:async';

import 'package:mobx/mobx.dart';

Future<T> until<T>(Object Function() getValue) {
  final completer = Completer<T>();
  autorun((context) {
    if (getValue() case T result) {
      completer.complete(result);
      context.dispose();
    }
  });
  return completer.future;
}
