// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:taiko_songs/src/parser/song_parser.dart';

Future<void> main(List<String> arguments) async {
  var url =
      'https://wikiwiki.jp/taiko-fumen/%E4%BD%9C%E5%93%81/NS2';
  var folder = Directory.systemTemp;
  folder = Directory(path.join(folder.path, 'taiko_songs'));
  await folder.create();
  var htmlFile = File(path.join(folder.path, 'ns2.html'));
  var songFile = File(path.join(folder.path, 'ns2.txt'));
  String body;
  if (!await htmlFile.exists()) {
    print('download html');
    var dio = Dio();
    var res = await dio.get(url);
    body = res.data;
    htmlFile.writeAsString(body);
  } else {
    print('read html');
    body = await htmlFile.readAsString();
  }
  var parser = SongParser();
  var songList = parser.parseSongList(body);
  var write = songFile.openWrite();
  int index = 0;
  await songList.forEach((it) {
    print("${++index} $it");
    write.writeln(it.name);
  });
  await write.close();
}
