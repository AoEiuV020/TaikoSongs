// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:taiko_songs/src/db/data.dart';

var logger = Logger('main');

Future<void> main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  var folder = Directory(path.join(Directory.systemTemp.path, 'taiko_songs'));
  var data = DataSource(folder);
  var list = data.getReleaseList();
  var release =
      await list.firstWhere((element) => element.name == '太鼓ミュージックパス');
  var songList = await data.getSongList(release).toList();
  var song = songList[Random().nextInt(songList.length)];
  var difficultyItem = song.difficultyMap.values.last;
  var difficulty = await data.getDifficulty(difficultyItem);
  print("${song.name}, $difficultyItem");
  print(difficulty.chartImageUrl);
}
