// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChampionRotation _$ChampionRotationFromJson(Map<String, dynamic> json) =>
    ChampionRotation(
      patchVersion: json['patchVersion'] as String?,
      duration: ChampionRotationDuration.fromJson(
          json['duration'] as Map<String, dynamic>),
      beginnerMaxLevel: (json['beginnerMaxLevel'] as num).toInt(),
      beginnerChampions: (json['beginnerChampions'] as List<dynamic>)
          .map((e) => Champion.fromJson(e as Map<String, dynamic>))
          .toList(),
      regularChampions: (json['regularChampions'] as List<dynamic>)
          .map((e) => Champion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChampionRotationToJson(ChampionRotation instance) =>
    <String, dynamic>{
      'patchVersion': instance.patchVersion,
      'duration': instance.duration,
      'beginnerMaxLevel': instance.beginnerMaxLevel,
      'beginnerChampions': instance.beginnerChampions,
      'regularChampions': instance.regularChampions,
    };

ChampionRotationDuration _$ChampionRotationDurationFromJson(
        Map<String, dynamic> json) =>
    ChampionRotationDuration(
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
    );

Map<String, dynamic> _$ChampionRotationDurationToJson(
        ChampionRotationDuration instance) =>
    <String, dynamic>{
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
    };

Champion _$ChampionFromJson(Map<String, dynamic> json) => Champion(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$ChampionToJson(Champion instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
    };
