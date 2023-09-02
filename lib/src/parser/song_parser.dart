import 'package:html/parser.dart';
import 'package:taiko_songs/src/bean/difficulty.dart';
import 'package:taiko_songs/src/bean/song.dart';
import 'package:taiko_songs/src/parser/base.dart';

class SongParser extends Parser {
  Stream<SongItem> parseList(String doc) async* {
    var root = parse(doc);
    var divList = root.querySelectorAll('#content > div');
    for (var div in divList) {
      if (div.className.trim() == 'navfold-container clearfix') {
        continue;
      }
      var category = "";
      var tableList = div.querySelectorAll('table');
      for (var table in tableList) {
        var thead = table.querySelector('thead');
        if (thead == null) {
          continue;
        }
        var headTrList = thead.children;
        int columnCount = -1;
        List<String> titleList = [
          '曲名',
          'BPM',
          'かんたん',
          'ふつう',
          'むずかしい',
          'おに',
          'おに(裏)'
        ];
        Map<String, int> indexMap = {};
        (1, 2, 3);
        var mayBeCategory = "";
        for (var tr in headTrList) {
          if (tr.children.length == 1) {
            mayBeCategory = tr.text;
          }
          for (var (i, td) in tr.children.indexed) {
            var text = td.text
                .trim()
                .replaceAll(' ', '')
                .replaceAll(' ', '')
                .replaceAll('*1', '');
            var titleIndex = titleList.indexOf(text);
            if (titleIndex == -1) {
              continue;
            }
            indexMap[text] = i;
          }
          bool skip = false;
          for (var titleIndex in [0, 1]) {
            if (indexMap[titleList[titleIndex]] == null) {
              skip = true;
            }
          }
          if (skip) {
            continue;
          }
          columnCount = indexMap.length;
        }
        if (columnCount == -1) {
          continue;
        }
        category = mayBeCategory;
        var songList = table.querySelectorAll('tbody > tr');
        for (var tr in songList) {
          if (tr.children.length < columnCount) {
            if (tr.children.length == 1) {
              category = tr.text;
            }
            continue;
          }
          var nameTd = tr.children[indexMap[titleList[0]]!];
          var name = nameTd.children[0].text.trim();
          var subtitleSpan = nameTd.querySelector('span');
          var subtitle = subtitleSpan?.text.trim() ?? "";
          var bpm = tr.children[indexMap[titleList[1]]!].text;
          for (int i = 2; i < titleList.length; i++) {
            var index = indexMap[titleList[i]];
            if (index == null) {
              continue;
            }
          }
          Map<DifficultyType, DifficultyItem> difficultyMap = {};
          for (var (i, title) in titleList.sublist(2).indexed) {
            var type = DifficultyType.values[i];
            var tdIndex = indexMap[title];
            if (tdIndex == null) {
              continue;
            }
            if (tr.children.length <= tdIndex) {
              continue;
            }
            var td = tr.children[tdIndex];
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
            var url = a.attributes['href']!;
            var difficulty = DifficultyItem(type, level, hasBranch, url);
            difficultyMap[type] = difficulty;
          }
          var song = SongItem(name, subtitle, category, bpm, difficultyMap);
          yield song;
        }
      }
    }
  }
}
