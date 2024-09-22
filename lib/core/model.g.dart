// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChampionRotation _$ChampionRotationFromJson(Map<String, dynamic> json) =>
    ChampionRotation(
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
      'beginnerMaxLevel': instance.beginnerMaxLevel,
      'beginnerChampions': instance.beginnerChampions,
      'regularChampions': instance.regularChampions,
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
