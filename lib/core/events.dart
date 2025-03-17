import 'package:flutter/foundation.dart';

class AppEvents {
  final predictionsEnabledChanged = EventNotifier();
  final rotationBookmarkChanged = EventNotifier();
  final championObserveChanged = EventNotifier();
}

class EventNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
