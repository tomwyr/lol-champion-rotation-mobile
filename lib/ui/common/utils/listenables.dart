import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

class ReactionNotifier<T> extends ChangeNotifier {
  ReactionNotifier(ValueGetter<T> fn) {
    _disposeReaction = reaction((_) => fn(), (_) => notifyListeners());
  }

  late final ReactionDisposer _disposeReaction;

  @override
  void dispose() {
    _disposeReaction();
    super.dispose();
  }
}
