// ignore_for_file: avoid_print

import 'package:logging/logging.dart';
import 'package:taiko_songs/src/db/data.dart';

var logger = Logger('main');

Future<void> main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  var data = DataSource();
  var list = data.getReleaseList();
  var release =
      await list.firstWhere((element) => element.name == '太鼓ミュージックパス');
  var songList = await data.getSongList(release).toList();
  var song = songList[0];
  var difficultyItem = song.difficultyMap.values.last;
  var difficulty = await data.getDifficulty(difficultyItem);
  print("${song.name}, $difficultyItem");
  print(difficulty.chartImageUrl);
  var table = difficulty.table;
  for (var data in table.data) {
    print("title: ${data.title.text}");
    print(data.indexMap.map((key, value) => MapEntry(key, data.get(key).text)));
  }
}
