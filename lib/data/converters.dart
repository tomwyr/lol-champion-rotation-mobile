import 'package:json_annotation/json_annotation.dart';

import '../core/model/champion.dart';

class ChampionDetailsHistoryEventsConverter
    extends JsonConverter<List<ChampionDetailsHistoryEvent>, List> {
  const ChampionDetailsHistoryEventsConverter();

  @override
  List<ChampionDetailsHistoryEvent> fromJson(List json) {
    final converter = ChampionDetailsHistoryEventConverter();
    final result = <ChampionDetailsHistoryEvent>[];

    for (Map<String, dynamic> eventJson in json) {
      try {
        final event = converter.fromJson(eventJson);
        result.add(event);
      } on UnknownJsonUnionType catch (_) {
        continue;
      }
    }

    return result;
  }

  @override
  List toJson(List<ChampionDetailsHistoryEvent> object) {
    return [for (var event in object) event.toJson()];
  }
}

class ChampionDetailsHistoryEventConverter {
  ChampionDetailsHistoryEvent fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    return switch (type) {
      'rotation' => ChampionDetailsHistoryRotation.fromJson(json),
      'bench' => ChampionDetailsHistoryBench.fromJson(json),
      'release' => ChampionDetailsHistoryRelease.fromJson(json),
      _ => throw UnknownJsonUnionType('Unknown or missing ChampionDetailsHistoryEvent type: $type'),
    };
  }
}

class UnknownJsonUnionType implements Exception {
  UnknownJsonUnionType(this.cause);

  final String cause;
}
