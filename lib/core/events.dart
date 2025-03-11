import 'package:flutter/foundation.dart';

class AppEvents {
  final predictionsEnabledChanged = EventNotifier();
}

class EventNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
