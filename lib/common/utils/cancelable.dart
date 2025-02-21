class Cancelable {
  bool _canceled = false;
  bool get canceled => _canceled;

  void cancel() {
    _canceled = true;
  }
}

class CancelableSwitcher {
  Cancelable? _activeTask;

  Cancelable startNew() {
    final task = Cancelable();
    _activeTask?.cancel();
    _activeTask = task;
    return task;
  }

  void cancel() {
    _activeTask?.cancel();
    _activeTask = null;
  }
}
