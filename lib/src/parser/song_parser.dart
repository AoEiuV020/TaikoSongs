import 'package:html/parser.dart';
import 'package:taiko_songs/src/bean/difficulty.dart';
import 'package:taiko_songs/src/bean/song.dart';
import 'package:tuple/tuple.dart';

class SongParser {
  Stream<SongItem> parseSongList(String doc) async* {
    var root = parse(doc);
    var divList = root.querySelectorAll('#content > div');
    for (var div in divList) {
      if (div.className.trim() == 'navfold-container clearfix') {
        continue;
      }
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
        for (var tr in headTrList) {
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
        var songList = table.querySelectorAll('tbody > tr');
        for (var tr in songList) {
          if (tr.children.length < columnCount) {
            continue;
          }
          var name = tr.children[indexMap[titleList[0]]!].children[0].text;
          var bpm = tr.children[indexMap[titleList[1]]!].text;
          for (int i = 2; i < titleList.length; i++) {
            var index = indexMap[titleList[i]];
            if (index == null) {
              continue;
            }
          }
          var difficultyList = await Stream.fromIterable(titleList.sublist(2))
              .map((event) => indexMap[event])
              .where((event) => event != null)
              .map((event) => event!)
              .where((event) {
                return tr.children.length > event;
              })
              .map((event) => tr.children[event])
              .map((event) => event.querySelector('a'))
              .where((event) => event != null)
              .map((event) => event!)
              .map((event) => Tuple2(event.attributes['href']!, event.text))
              .where((event) {
                return event.item2.startsWith('★×');
              })
              .map((event) => event.withItem2(event.item2.substring(2)))
              .map((event) => Tuple2(event.item1, int.parse(event.item2)))
              .map((event) => DifficultyItem(
                  DifficultyType.easy, event.item2, false, event.item1))
              .toList();
          var song = SongItem(name, "", "", bpm, difficultyList);
          yield song;
        }
      }
    }
  }
}
