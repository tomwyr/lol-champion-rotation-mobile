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
    required this.history,
  });

  final String id;
  final String name;
  final String title;
  final String imageUrl;
  final List<ChampionDetailsAvailability> availability;
  final ChampionDetailsOverview overview;
  final List<ChampionDetailsHistoryEvent> history;

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

sealed class ChampionDetailsHistoryEvent {
  ChampionDetailsHistoryEvent();

  factory ChampionDetailsHistoryEvent.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    return switch (type) {
      'rotation' => ChampionDetailsHistoryRotation.fromJson(json),
      'bench' => ChampionDetailsHistoryBench.fromJson(json),
      _ => throw ArgumentError('Unknown or missing ChampionDetailsHistoryEvent type: $type'),
    };
  }

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class ChampionDetailsHistoryRotation extends ChampionDetailsHistoryEvent {
  ChampionDetailsHistoryRotation({
    required this.id,
    required this.duration,
    required this.current,
    required this.championImageUrls,
  });

  final String id;
  final ChampionRotationDuration duration;
  final bool current;
  final List<String> championImageUrls;

  factory ChampionDetailsHistoryRotation.fromJson(Map<String, dynamic> json) =>
      _$ChampionDetailsHistoryRotationFromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'type': 'rotation',
        ..._$ChampionDetailsHistoryRotationToJson(this),
      };
}

@JsonSerializable()
class ChampionDetailsHistoryBench extends ChampionDetailsHistoryEvent {
  ChampionDetailsHistoryBench({
    required this.rotationsMissed,
  });

  final int rotationsMissed;

  factory ChampionDetailsHistoryBench.fromJson(Map<String, dynamic> json) =>
      _$ChampionDetailsHistoryBenchFromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'type': 'bench',
        ..._$ChampionDetailsHistoryBenchToJson(this),
      };
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
