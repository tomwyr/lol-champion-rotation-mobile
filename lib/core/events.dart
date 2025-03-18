import 'package:flutter/foundation.dart';

class AppEvents {
  final predictionsEnabledChanged = EventNotifier();
  final rotationBookmarksChanged = EventNotifier();
  final championBookmarksChanged = EventNotifier();
}

class EventNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
