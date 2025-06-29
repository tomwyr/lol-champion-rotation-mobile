import 'dart:async';

import 'package:flutter/foundation.dart';

class StreamNotifier<T> extends ChangeNotifier {
  StreamNotifier(Stream<T> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
