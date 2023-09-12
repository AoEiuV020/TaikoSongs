import 'package:json_annotation/json_annotation.dart';

import 'difficulty.dart';

part 'song.g.dart';

@JsonSerializable()
class SongItem {
  final String name;
  final String subtitle;
  final String category;
  final int? categoryColor;
  final String bpm;
  final Map<DifficultyType, DifficultyItem> difficultyMap;

  SongItem(this.name, this.subtitle, this.category, this.categoryColor,
      this.bpm, this.difficultyMap);

  @override
  String toString() {
    return '$name, subtitle: $subtitle, category: $category, bpm: $bpm, difficulty: ${difficultyMap.values}';
  }

  int getLevelTypeDifficulty(DifficultyType type) {
    return difficultyMap[type]?.level ?? 0;
  }

  factory SongItem.fromJson(Map<String, dynamic> json) =>
      _$SongItemFromJson(json);

  Map<String, dynamic> toJson() => _$SongItemToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SongItem &&
              runtimeType == other.runtimeType &&
              name == other.name;

  @override
  int get hashCode => name.hashCode;
}

enum SongCategory {
  pops, // ポップス（流行）
  anime, // アニメ（动画）
  vocaloid, // ボーカロイド™ 曲 (虚拟歌姬合成音乐)
  variety, // バラエティ（综合）
  classic, // クラシック（古典）
  gameMusic, // ゲーム ミュージック (游戏)
  namcoOriginal, // ナムコオリジナル (原创)
}
