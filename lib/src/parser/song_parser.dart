import 'package:html/parser.dart';
import 'package:taiko_songs/src/bean/difficulty.dart';
import 'package:taiko_songs/src/bean/song.dart';
import 'package:taiko_songs/src/parser/base.dart';

class SongParser extends Parser {
  Stream<SongItem> parseList(String baseUrl, String doc) async* {
    var root = parse(doc);
    var divList = root.querySelectorAll('#content > div');
    for (var div in divList) {
      if (div.className.trim() == 'navfold-container clearfix') {
        continue;
      }
      var tableList =
          div.querySelectorAll('table').map((e) => parseTable(e)).toList();
      for (var table in tableList) {
        var headCellList = table.head?.content;
        if (headCellList == null) {
          continue;
        }
        var bpmIndex = -1;
        for (var i = 0; i < headCellList.length; i++) {
          if (i - 1 < 0 || i + 4 >= headCellList.length) {
            // BPM前面是曲名， 后面是至少四个难度,
            continue;
          }
          var cell = headCellList[i];
          if (cell.text.startsWith("BPM")) {
            bpmIndex = i;
            break;
          }
        }
        if (bpmIndex == -1) {
          continue;
        }
        yield* Stream.fromIterable(table.data).map((data) {
          var category = data.title.text;
          var nameTd = data.getByIndex(bpmIndex - 1).ele;
          var name = nameTd.children[0].text.trim();
          var subtitleSpan = nameTd.querySelector('span');
          var subtitle = subtitleSpan?.text.trim() ?? "";
          var bpm = data.getByIndex(bpmIndex).text;
          Map<DifficultyType, DifficultyItem> difficultyMap = {};
          for (var (i, cell)
              in data.row.content.sublist(bpmIndex + 1).indexed) {
            var type = DifficultyType.values[i];
            var td = cell.ele;
            var a = td.querySelector('a');
            if (a == null) {
              continue;
            }
            var text = a.text;
            if (!text.startsWith('★×')) {
              continue;
            }
            var levelText = text.substring(2);
            var level = int.parse(levelText);
            var span = td.querySelector('span');
            var hasBranch = span != null && span.text == "譜面分岐";
            var url = getAbsHref(baseUrl, a);
            var difficulty = DifficultyItem(type, level, hasBranch, url);
            difficultyMap[type] = difficulty;
          }
          var song = SongItem(name, subtitle, category, bpm, difficultyMap);
          return song;
        });
      }
    }
  }
}
