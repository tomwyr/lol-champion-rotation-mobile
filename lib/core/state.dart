import 'model.dart';

sealed class CurrentRotationState {}

class Initial extends CurrentRotationState {}

class Loading extends CurrentRotationState {}

class Data extends CurrentRotationState {
  Data(this.value);

  final ChampionRotation value;
}

class Error extends CurrentRotationState {
  Error(this.value);

  final CurrentRotationError value;
}
