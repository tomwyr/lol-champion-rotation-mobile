import 'package:flutter/foundation.dart';

class AppEvents {
  final predictionsEnabledChanged = EventNotifier();
  final observedRotationsChanged = EventNotifier();
  final observedChampionsChanged = EventNotifier();
}

class EventNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
