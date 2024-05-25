// ignore_for_file: avoid_print

import 'package:html/parser.dart';
import 'package:iron_db/iron_db.dart';
import 'package:taiko_songs/src/cache/html_cache.dart';
import 'package:taiko_songs/src/parser/base.dart';

Future<void> translateSongNamePS4() async {
  const url = 'https://www.jianshu.com/p/e84a47a43b0d';
  final list = await SongNameParserPS4().parseNameList(url).toList();
  int count = list.length;
  for (int i = 0; i < count; i++) {
    final st = list[i];
    print('${st.origin} ==> ${st.translated}');
  }
}

Future<void> translateSongNameNS2() async {
  const urlJp = 'https://dondafulfestival-20th.taiko-ch.net/music/songlist.php';
  const urlCn =
      'https://dondafulfestival-20th.taiko-ch.net/sc/music/songlist.php';
  final listCn = await SongNameParserNS2().parseNameList(urlCn).toList();
  final listJp = await SongNameParserNS2().parseNameList(urlJp).toList();
  int count = listJp.length;
  for (int i = 0; i < count; i++) {
    final jp = listJp[i];
    final cn = listCn[i];
    print('${jp.name} ==> ${cn.name}');
    if (jp.subtitle.isNotEmpty) {
      print('${jp.subtitle} ==> ${cn.subtitle}');
    }
  }
}

class SongNameParserPS4 extends Parser {
  Stream<SongTranslate> parseNameList(String url) async* {
    final body = await HtmlCache().request(Iron.db, url, false, false);
    final root = parse(body);
    var tableList = root.querySelectorAll('table').map((e) => parseTable(e));
    for (final table in tableList) {
      var headCellList = table.head?.content;
      if (headCellList == null) {
        continue;
      }
      final nameIndex =
          headCellList.indexWhere((element) => element.text == '曲目名称');
      if (nameIndex == -1) {
        continue;
      }
      for (final data in table.data) {
        final cell = data.getByIndex(nameIndex);
        final text = cell.text;
        final list = text.split('(');
        if (list.length < 2 || !list[1].endsWith(')')) {
          continue;
        }
        final translated = list[0];
        final origin = list[1].substring(0, list[1].length - 1);
        yield SongTranslate(translated, origin);
      }
    }
  }
}

class SongNameParserNS2 extends Parser {
  Stream<SongName> parseNameList(String url) async* {
    final body = await HtmlCache().request(Iron.db, url, false, false);
    final root = parse(body);
    final dlList = root.querySelectorAll('ul.songList > li > dl');
    yield* Stream.fromIterable(dlList).map((dl) {
      final dt = dl.children[0];
      final dd = dl.children[1];
      dt.querySelectorAll('rt').forEach((element) {
        element.remove();
      });
      dd.querySelectorAll('rt').forEach((element) {
        element.remove();
      });
      return SongName(dt.text.trim(), dd.text.trim());
    });
  }
}

class SongName {
  final String name;
  final String subtitle;

  SongName(this.name, this.subtitle);
}

class SongTranslate {
  final String translated;
  final String origin;

  SongTranslate(this.translated, this.origin);
}
