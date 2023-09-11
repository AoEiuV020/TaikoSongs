// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'difficulty.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DifficultyItem _$DifficultyItemFromJson(Map<String, dynamic> json) =>
    DifficultyItem(
      json['name'] as String,
      $enumDecode(_$DifficultyTypeEnumMap, json['type']),
      json['level'] as int,
      json['hasBranch'] as bool,
      json['url'] as String,
    );

Map<String, dynamic> _$DifficultyItemToJson(DifficultyItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$DifficultyTypeEnumMap[instance.type]!,
      'level': instance.level,
      'hasBranch': instance.hasBranch,
      'url': instance.url,
    };

const _$DifficultyTypeEnumMap = {
  DifficultyType.easy: 'easy',
  DifficultyType.normal: 'normal',
  DifficultyType.hard: 'hard',
  DifficultyType.oni: 'oni',
  DifficultyType.uraOni: 'uraOni',
};
