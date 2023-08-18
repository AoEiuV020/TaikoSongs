class DifficultyItem {
  final DifficultyType type;
  final int level;
  final bool hasBranch;
  final String url;

  DifficultyItem(this.type, this.level, this.hasBranch, this.url);

  @override
  String toString() {
    return '★×$level';
  }
}

class Difficulty {
  final int level;
  final int maxCombo;
  final String explan;
  final String chartImageUrl;

  Difficulty(this.level, this.maxCombo, this.explan, this.chartImageUrl);
}

enum DifficultyType {
  easy, // かんたん（简单）
  normal, // ふつう（普通）
  hard, // むずかしい（困难）
  oni, // おに（魔王）
  uraOni, // おに(裏)（里魔王）
}
