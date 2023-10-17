import 'package:json_annotation/json_annotation.dart';

part 'difficulty.g.dart';

@JsonSerializable()
class DifficultyItem {
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
}

enum DifficultyType {
  easy, // かんたん（简单）
  normal, // ふつう（普通）
  hard, // むずかしい（困难）
  oni, // おに（魔王）
  uraOni, // おに(裏)（里魔王）
}
