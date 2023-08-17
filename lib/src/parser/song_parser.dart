import 'package:html/parser.dart';
import 'package:taiko_songs/src/bean/song.dart';

class SongParser {
  Stream<Song> parseSongList(String doc) async* {
    var root = parse(doc);
    var tableList = root.querySelectorAll('table');
    for (var table in tableList) {
      var thead = table.querySelector('thead');
      if (thead == null) {
        continue;
      }
      bool skip = true;
      for (var td in thead.querySelectorAll('tr > td')) {
        if (td.text.trim() == '曲名') {
          skip = false;
        }
      }
      if (skip) {
        continue;
      }
      var songList = table.querySelectorAll('tbody > tr > td:nth-child(2)');
      for (var element in songList) {
        var nameElement = element.querySelector('strong');
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
