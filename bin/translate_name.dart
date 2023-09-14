// ignore_for_file: avoid_print

import 'package:html/parser.dart';
import 'package:taiko_songs/src/cache/html_cache.dart';
import 'package:taiko_songs/src/irondb/iron.dart';
import 'package:taiko_songs/src/parser/base.dart';

///
///
Future<void> printSongNameNS2() async {
  const urlJp = 'https://dondafulfestival-20th.taiko-ch.net/music/songlist.php';
  const urlCn =
      'https://dondafulfestival-20th.taiko-ch.net/sc/music/songlist.php';
  final listCn = await SongNameParser().parseNameList(urlCn).toList();
  final listJp = await SongNameParser().parseNameList(urlJp).toList();
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

class SongNameParser extends Parser {
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
