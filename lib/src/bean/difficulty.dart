import 'package:taiko_songs/src/parser/table.dart';

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

  static final Map<DifficultyType, String> difficultyTypeStringMap = {
    DifficultyType.easy: '梅',
    DifficultyType.normal: '竹',
    DifficultyType.hard: '松',
    DifficultyType.oni: '鬼',
    DifficultyType.uraOni: '里鬼',
  };
}

class Difficulty {
  final Table table;
  final int level;
  final int maxCombo;
  final String explain;
  final String chartImageUrl;

  Difficulty(
      this.table, this.level, this.maxCombo, this.explain, this.chartImageUrl);
}

enum DifficultyType {
  easy, // かんたん（简单）
  normal, // ふつう（普通）
  hard, // むずかしい（困难）
  oni, // おに（魔王）
  uraOni, // おに(裏)（里魔王）
}
