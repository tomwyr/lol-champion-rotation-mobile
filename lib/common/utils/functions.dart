import 'dart:async';

import 'package:flutter/scheduler.dart';

Future<void> get afterFrame {
  final completer = Completer();
  SchedulerBinding.instance.addPostFrameCallback((_) => completer.complete());
  return completer.future;
}

Future<void> delay({int seconds = 0, int milliseconds = 0}) {
  return Future.delayed(Duration(
    seconds: seconds,
    milliseconds: milliseconds,
  ));
}
