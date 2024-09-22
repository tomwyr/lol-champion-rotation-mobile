import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class ChampionRotation {
  ChampionRotation({
    required this.beginnerMaxLevel,
    required this.beginnerChampions,
    required this.regularChampions,
  });

  final int beginnerMaxLevel;
  final List<Champion> beginnerChampions;
  final List<Champion> regularChampions;

  factory ChampionRotation.fromJson(Map<String, dynamic> json) => _$ChampionRotationFromJson(json);

  Map<String, dynamic> toJson() => _$ChampionRotationToJson(this);
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

enum CurrentRotationError {
  unavailable,
}
