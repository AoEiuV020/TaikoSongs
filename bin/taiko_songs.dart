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
  var release = await list
      .firstWhere((element) => element.name == '太鼓の達人 ドコドン！ミステリーアドベンチャー（3DS3）');
  var songList = await data.getSongList(release).toList();
  for (var song in songList) {
    print("${song.name}, ${song.difficultyMap.values}");
  }
}
