import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:taiko_songs/src/compare/then_compare.dart';

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

  factory SongItem.fromLine(String line) {
    final strList = line.split('\t');
    return SongItem(
      strList[0],
      strList[1],
      strList[2],
      categoryColorFromLine(strList[3]),
      strList[4],
      difficultyFromLine(strList[0], strList[5]),
    );
  }

  static int? categoryColorFromLine(String line) =>
      line == '' ? null : int.parse(line, radix: 16);

  static Map<DifficultyType, DifficultyItem> difficultyFromLine(
          String name, String line) =>
      {
        for (final item in line
            .split('|')
            .where((element) => element.isNotEmpty)
            .map((e) => e.startsWith('`') ? (name + e) : e)
            .map((e) => DifficultyItem.fromLine(e)))
          item.type: item
      };

  String toLine() => [
        name,
        subtitle,
        category,
        categoryColor == null ? '' : categoryColor!.toRadixString(16),
        bpm,
        difficultyToLine(),
      ].join('\t');

  String difficultyToLine() => DifficultyType.values
      .map((e) => difficultyMap[e]?.toLine() ?? '')
      .map((e) => e.startsWith(name) ? e.replaceFirst(name, '') : e)
      .join('|');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongItem &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  static Comparator<SongItem> makeComparator(Map<String, bool> sortMap) {
    Comparator<SongItem> base = (c1, c2) => 0;
    sortMap.keys.toList().reversed.forEach((key) {
      final value = sortMap[key]!;
      KeyExtractor<SongItem, Comparable<dynamic>> keyExtractor;
      // 有就优先，
      KeyExtractor<SongItem, Comparable<dynamic>>? first;
      if (key == 'bpm') {
        keyExtractor = (s) =>
            double.parse(RegExp(r'[\d.]+').allMatches(s.bpm).last.group(0)!);
      } else if (key == 'category') {
        keyExtractor = (s) => s.category;
      } else if (key == 'subtitle') {
        keyExtractor = (s) => s.subtitle;
      } else if (key == 'name') {
        keyExtractor = (s) => s.name;
      } else {
        final type = $enumDecode(DifficultyItem.difficultyTypeStringMap, key);
        keyExtractor = (s) => s.getLevelTypeDifficulty(type);
        // 排里鬼时不要把没有的情况排到前面，
        first = (s) => s.getLevelTypeDifficulty(type) == 0 ? 1 : 0;
      }
      var comparator = comparing(keyExtractor);
      if (value) {
        comparator = comparator.inverse;
      }
      if (first != null) {
        comparator = comparing(first).then(comparator);
      }
      base = base.then(comparator);
    });
    return base;
  }
}

enum SongSortKey {
  category,
  name,
  subtitle,
  bpm,
  easy, // かんたん（简单）
  normal, // ふつう（普通）
  hard, // むずかしい（困难）
  oni, // おに（魔王）
  uraOni, // おに(裏)（里魔王）
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
