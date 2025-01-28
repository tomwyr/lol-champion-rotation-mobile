import 'package:json_annotation/json_annotation.dart';

part 'rotation.g.dart';

enum RotationType {
  regular,
  beginner,
}

@JsonSerializable()
class ChampionRotation {
  ChampionRotation({
    required this.patchVersion,
    required this.duration,
    required this.beginnerMaxLevel,
    required this.beginnerChampions,
    required this.regularChampions,
  });

  final String? patchVersion;
  final ChampionRotationDuration duration;
  final int beginnerMaxLevel;
  final List<Champion> beginnerChampions;
  final List<Champion> regularChampions;

  factory ChampionRotation.fromJson(Map<String, dynamic> json) => _$ChampionRotationFromJson(json);

  Map<String, dynamic> toJson() => _$ChampionRotationToJson(this);
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
class Champion {
  Champion({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String imageUrl;

  factory Champion.fromJson(Map<String, dynamic> json) => _$ChampionFromJson(json);

  Map<String, dynamic> toJson() => _$ChampionToJson(this);
}
