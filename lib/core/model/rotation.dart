import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

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
  });

  final String? patchVersion;
  final String? nextRotationToken;
  final ChampionRotationDuration duration;
  final List<Champion> champions;

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

@JsonSerializable()
class FilterRotationsResult {
  FilterRotationsResult({
    required this.regularRotations,
    required this.beginnerRotation,
  });

  final List<FilteredRegularRotation> regularRotations;
  final FilteredBeginnerRotation? beginnerRotation;

  factory FilterRotationsResult.fromJson(Map<String, dynamic> json) =>
      _$FilterRotationsResultFromJson(json);

  Map<String, dynamic> toJson() => _$FilterRotationsResultToJson(this);
}

@CopyWith()
@JsonSerializable()
class FilteredRegularRotation {
  FilteredRegularRotation({
    required this.champions,
    required this.duration,
    required this.current,
  });

  final List<Champion> champions;
  final ChampionRotationDuration duration;
  final bool current;

  factory FilteredRegularRotation.fromJson(Map<String, dynamic> json) =>
      _$FilteredRegularRotationFromJson(json);

  Map<String, dynamic> toJson() => _$FilteredRegularRotationToJson(this);
}

@CopyWith()
@JsonSerializable()
class FilteredBeginnerRotation {
  FilteredBeginnerRotation({
    required this.champions,
  });

  final List<Champion> champions;

  factory FilteredBeginnerRotation.fromJson(Map<String, dynamic> json) =>
      _$FilteredBeginnerRotationFromJson(json);

  Map<String, dynamic> toJson() => _$FilteredBeginnerRotationToJson(this);
}
