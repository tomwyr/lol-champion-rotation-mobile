import 'dart:async';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/foundation.dart';

import '../../data/api_client.dart';
import '../model/rotation.dart';
import '../state.dart';

part 'rotation_details.g.dart';

class RotationDetailsStore {
  RotationDetailsStore({required this.apiClient});

  final AppApiClient apiClient;

  final ValueNotifier<RotationDetailsState> state = ValueNotifier(Initial());
  final StreamController<RotationDetailsEvent> events = StreamController.broadcast();

  late String _rotationId;

  void initialize(String rotationId) {
    _rotationId = rotationId;
    _loadRotation();
  }

  void _loadRotation() async {
    if (state.value case Loading()) {
      return;
    }

    state.value = Loading();

    try {
      final rotation = await apiClient.rotation(rotationId: _rotationId);
      state.value = Data(RotationDetailsData(rotation: rotation));
    } catch (_) {
      state.value = Error();
    }
  }

  void toggleBookmark() async {
    final RotationDetailsData currentData;
    if (state.value case Data(:var value) when !value.togglingBookmark) {
      currentData = value;
    } else {
      return;
    }

    state.value = Data(currentData.copyWith(togglingBookmark: true));
    try {
      final input = ObserveRotationInput(observing: !currentData.rotation.observing);
      await apiClient.observeRotation(_rotationId, input);
      final updatedData = currentData.copyWith(
        details: currentData.rotation.copyWith(observing: input.observing),
      );
      state.value = Data(updatedData);
    } catch (_) {
      events.add(RotationDetailsEvent.bookmarkingFailed);
      state.value = Data(currentData);
    }
  }
}

@CopyWith()
class RotationDetailsData {
  RotationDetailsData({
    required this.rotation,
    this.togglingBookmark = false,
  });

  final ChampionRotationDetails rotation;
  final bool togglingBookmark;
}

enum RotationDetailsEvent {
  bookmarkingFailed,
}

typedef RotationDetailsState = DataState<RotationDetailsData>;
