import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import 'champion.dart';

part 'rotation.g.dart';

enum ChampionRotationType {
  regular,
  beginner,
}

@JsonSerializable()
class CurrentChampionRotation {
  CurrentChampionRotation({
    required this.patchVersion,
    required this.duration,
    required this.beginnerMaxLevel,
    required this.beginnerChampions,
    required this.regularChampions,
    required this.nextRotationToken,
  });

  final String? patchVersion;
  final ChampionRotationDuration duration;
  final int beginnerMaxLevel;
  final List<Champion> beginnerChampions;
  final List<Champion> regularChampions;
  final String? nextRotationToken;

  factory CurrentChampionRotation.fromJson(Map<String, dynamic> json) =>
      _$CurrentChampionRotationFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentChampionRotationToJson(this);
}

@JsonSerializable()
class ChampionRotation {
  ChampionRotation({
    required this.patchVersion,
    required this.duration,
    required this.champions,
    required this.nextRotationToken,
    required this.current,
  });

  final String? patchVersion;
  final String? nextRotationToken;
  final ChampionRotationDuration duration;
  final List<Champion> champions;
  final bool current;

  factory ChampionRotation.fromJson(Map<String, dynamic> json) => _$ChampionRotationFromJson(json);

  Map<String, dynamic> toJson() => _$ChampionRotationToJson(this);
}

@CopyWith()
@JsonSerializable()
class ChampionRotationDetails {
  ChampionRotationDetails({
    required this.duration,
    required this.champions,
    required this.current,
    required this.observing,
  });

  final ChampionRotationDuration duration;
  final List<Champion> champions;
  final bool current;
  final bool observing;

  factory ChampionRotationDetails.fromJson(Map<String, dynamic> json) =>
      _$ChampionRotationDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ChampionRotationDetailsToJson(this);
}

@JsonSerializable()
class ChampionRotationDuration {
  ChampionRotationDuration({
    required this.start,
    required this.end,
  });

  final DateTime start;
  final DateTime end;

  factory ChampionRotationDuration.fromJson(Map<String, dynamic> json) =>
      _$ChampionRotationDurationFromJson(json);

  Map<String, dynamic> toJson() => _$ChampionRotationDurationToJson(this);
}

@JsonSerializable()
class ChampionRotationPrediction {
  ChampionRotationPrediction({
    required this.duration,
    required this.champions,
  });

  final ChampionRotationDuration duration;
  final List<Champion> champions;

  factory ChampionRotationPrediction.fromJson(Map<String, dynamic> json) =>
      _$ChampionRotationPredictionFromJson(json);

  Map<String, dynamic> toJson() => _$ChampionRotationPredictionToJson(this);
}

@JsonSerializable()
class ObserveRotationInput {
  ObserveRotationInput({
    required this.observing,
  });

  final bool observing;

  factory ObserveRotationInput.fromJson(Map<String, dynamic> json) =>
      _$ObserveRotationInputFromJson(json);

  Map<String, dynamic> toJson() => _$ObserveRotationInputToJson(this);
}
