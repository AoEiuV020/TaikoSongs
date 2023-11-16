import 'package:json_annotation/json_annotation.dart';

import '../util/serialize.dart';

part 'difficulty.g.dart';

@JsonSerializable()
class DifficultyItem {
  static const baseUrl =
      'https://wikiwiki.jp/taiko-fumen/%E5%8F%8E%E9%8C%B2%E6%9B%B2';
  final String name;
  final DifficultyType type;
  final int level;
  final bool hasBranch;
  final String url;

  DifficultyItem(this.name, this.type, this.level, this.hasBranch, this.url);

  factory DifficultyItem.uraOni(DifficultyItem item) {
    return DifficultyItem(
        item.name, DifficultyType.uraOni, item.level, item.hasBranch, item.url);
  }

  @override
  String toString() {
    return '${difficultyTypeStringMap[type]}★×$level${hasBranch ? '※' : ''}';
  }

  factory DifficultyItem.fromJson(Map<String, dynamic> json) =>
      _$DifficultyItemFromJson(json);

  Map<String, dynamic> toJson() => _$DifficultyItemToJson(this);

  static DifficultyItem fromLine(String line) {
    final strList = line.split('`');
    return DifficultyItem(
      strList[0],
      $enumDecode(_$DifficultyTypeEnumMap, strList[1]),
      int.parse(strList[2]),
      bool.parse(strList[3]),
      BeanSerialize.deserialize(baseUrl, strList[4]),
    );
  }

  String toLine() => [
        name,
        _$DifficultyTypeEnumMap[type]!,
        level.toString(),
        hasBranch.toString(),
        BeanSerialize.serialize(baseUrl, url),
      ].join('`');

  static final Map<DifficultyType, String> difficultyTypeStringMap = {
    DifficultyType.easy: '梅',
    DifficultyType.normal: '竹',
    DifficultyType.hard: '松',
    DifficultyType.oni: '鬼',
    DifficultyType.uraOni: '里鬼',
  };
  static final Map<DifficultyType, int> difficultyTypeColorMap = {
    DifficultyType.easy: 0xd52700,
    DifficultyType.normal: 0x769e11,
    DifficultyType.hard: 0x297ba3,
    DifficultyType.oni: 0xaf1e7f,
    DifficultyType.uraOni: 0x6042dd,
  };
}

@JsonSerializable()
class Difficulty {
  final int level;
  final int maxCombo;
  final String explain;
  final String chartImageUrl;

  Difficulty(this.level, this.maxCombo, this.explain, this.chartImageUrl);

  factory Difficulty.fromJson(Map<String, dynamic> json) =>
      _$DifficultyFromJson(json);

  Map<String, dynamic> toJson() => _$DifficultyToJson(this);

  static Difficulty fromLine(String line) {
    final strList = line.split('`');
    return Difficulty(
      int.parse(strList[0]),
      int.parse(strList[1]),
      strList[2],
      strList[3],
    );
  }

  String toLine() => [
        level.toString(),
        maxCombo.toString(),
        explain,
        chartImageUrl,
      ].join('`');
}

enum DifficultyType {
  easy, // かんたん（简单）
  normal, // ふつう（普通）
  hard, // むずかしい（困难）
  oni, // おに（魔王）
  uraOni, // おに(裏)（里魔王）
}
