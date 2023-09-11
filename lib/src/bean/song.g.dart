// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SongItem _$SongItemFromJson(Map<String, dynamic> json) => SongItem(
      json['name'] as String,
      json['subtitle'] as String,
      json['category'] as String,
      json['bpm'] as String,
      (json['difficultyMap'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$DifficultyTypeEnumMap, k),
            DifficultyItem.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$SongItemToJson(SongItem instance) => <String, dynamic>{
      'name': instance.name,
      'subtitle': instance.subtitle,
      'category': instance.category,
      'bpm': instance.bpm,
      'difficultyMap': instance.difficultyMap
          .map((k, e) => MapEntry(_$DifficultyTypeEnumMap[k]!, e)),
    };

const _$DifficultyTypeEnumMap = {
  DifficultyType.easy: 'easy',
  DifficultyType.normal: 'normal',
  DifficultyType.hard: 'hard',
  DifficultyType.oni: 'oni',
  DifficultyType.uraOni: 'uraOni',
};
