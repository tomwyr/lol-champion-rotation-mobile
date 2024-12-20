import 'package:flutter/foundation.dart';

import '../data/repository.dart';
import 'model.dart';
import 'state.dart';

class RotationStore {
  RotationStore({required this.repository});

  final RotationRepository repository;

  final ValueNotifier<CurrentRotationState> state = ValueNotifier(Initial());

  Future<void> loadCurrentRotation() async {
    if (state.value case Loading()) {
      return;
    }

    state.value = Loading();

    await _fetchCurrentRotation();
  }

  Future<void> refreshCurrentRotation() async {
    if (state.value case Loading()) {
      return;
    }

    await _fetchCurrentRotation();
  }

  Future<void> _fetchCurrentRotation() async {
    try {
      final currentRotation = await repository.currentRotation();
      state.value = Data(currentRotation);
    } on CurrentRotationError catch (error) {
      state.value = Error(error);
    }
  }
}
