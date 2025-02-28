import 'package:json_annotation/json_annotation.dart';

import 'rotation.dart';

part 'champion.g.dart';

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
class ChampionDetails {
  ChampionDetails({
    required this.id,
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.availability,
    required this.overview,
    // required this.rotations,
  });

  final String id;
  final String name;
  final String title;
  final String imageUrl;
  final List<ChampionDetailsAvailability> availability;
  final ChampionDetailsOverview overview;
  // final List<ChampionDetailsRotation> rotations;

  factory ChampionDetails.fromJson(Map<String, dynamic> json) => _$ChampionDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ChampionDetailsToJson(this);
}

@JsonSerializable()
class ChampionDetailsAvailability {
  ChampionDetailsAvailability({
    required this.rotationType,
    required this.lastAvailable,
    required this.current,
  });

  final ChampionRotationType rotationType;
  final DateTime? lastAvailable;
  final bool current;

  factory ChampionDetailsAvailability.fromJson(Map<String, dynamic> json) =>
      _$ChampionDetailsAvailabilityFromJson(json);

  Map<String, dynamic> toJson() => _$ChampionDetailsAvailabilityToJson(this);
}

@JsonSerializable()
class ChampionDetailsOverview {
  ChampionDetailsOverview({
    required this.occurrences,
    required this.popularity,
    required this.currentStreak,
  });

  final int occurrences;
  final int popularity;
  final int currentStreak;

  factory ChampionDetailsOverview.fromJson(Map<String, dynamic> json) =>
      _$ChampionDetailsOverviewFromJson(json);

  Map<String, dynamic> toJson() => _$ChampionDetailsOverviewToJson(this);
}

@JsonSerializable()
class ChampionDetailsRotation {
  ChampionDetailsRotation({
    required this.id,
    required this.duration,
    required this.current,
    required this.rotationsSinceLastSeen,
    required this.championImageUrls,
  });

  final String id;
  final ChampionRotationDuration duration;
  final bool current;
  final int rotationsSinceLastSeen;
  final List<String> championImageUrls;

  factory ChampionDetailsRotation.fromJson(Map<String, dynamic> json) =>
      _$ChampionDetailsRotationFromJson(json);

  Map<String, dynamic> toJson() => _$ChampionDetailsRotationToJson(this);
}

@JsonSerializable()
class SearchChampionsResult {
  SearchChampionsResult({
    required this.matches,
  });

  final List<SearchChampionsMatch> matches;

  factory SearchChampionsResult.fromJson(Map<String, dynamic> json) =>
      _$SearchChampionsResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchChampionsResultToJson(this);
}

@JsonSerializable()
class SearchChampionsMatch {
  SearchChampionsMatch({
    required this.champion,
    required this.availableIn,
  });

  final Champion champion;
  final List<ChampionRotationType> availableIn;

  factory SearchChampionsMatch.fromJson(Map<String, dynamic> json) =>
      _$SearchChampionsMatchFromJson(json);

  Map<String, dynamic> toJson() => _$SearchChampionsMatchToJson(this);
}
