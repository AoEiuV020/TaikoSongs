// ignore_for_file: avoid_print

import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:taiko_songs/src/cache/html_cache.dart';
import 'package:taiko_songs/src/parser/song_parser.dart';

Future<void> main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  var url =
      'https://wikiwiki.jp/taiko-fumen/%E4%BD%9C%E5%93%81/NS2/%E5%A4%AA%E9%BC%93%E3%83%9F%E3%83%A5%E3%83%BC%E3%82%B8%E3%83%83%E3%82%AF%E3%83%91%E3%82%B9';
  var folder = Directory(path.join(Directory.systemTemp.path, 'taiko_songs'));
  var songFile = File(path.join(folder.path, 'ns2pass.txt'));
  var body = await HtmlCache().request(url);
  var parser = SongParser();
  var songList = parser.parseSongList(body);
  var write = songFile.openWrite();
  int index = 0;
  Map<String, int> categoryMap = {};
  await songList.forEach((it) {
    print("${++index} $it");
    categoryMap[it.category] = (categoryMap[it.category] ?? 0) + 1;
    write.writeln(it.name);
  });
  print(categoryMap);
  await write.close();
}
