import 'package:html/parser.dart';
import 'package:taiko_songs/src/bean/song.dart';

class SongParser {
  Stream<Song> parseSongList(String doc) async* {
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
        int nameIndex = -1;
        int bpmIndex = -1;
        int columnCount = -1;
        for (var tr in headTrList) {
          var headTextList = tr.children.map((e) => e.text.trim()).toList();
          for (int i = 0; i < headTextList.length; i++) {
            var title = headTextList[i];
            if (title == '曲名') {
              nameIndex = i;
              continue;
            }
            if (title.startsWith('BPM')) {
              bpmIndex = i;
              continue;
            }
          }
          if (nameIndex != -1 && bpmIndex != -1) {
            columnCount = headTextList.length;
          }
        }
        if (columnCount == -1) {
          continue;
        }
        var songList = table.querySelectorAll('tbody > tr');
        for (var tr in songList) {
          if (tr.children.length != columnCount) {
            continue;
          }
          var td = tr.children[nameIndex];
          var nameElement = td.querySelector('strong');
          if (nameElement == null) {
            continue;
          }
          var name = nameElement.text;
          var song = Song(name);
          yield song;
        }
      }
    }
  }
}
