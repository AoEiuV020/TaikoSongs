// ignore_for_file: avoid_print

import 'package:logging/logging.dart';
import 'package:taiko_songs/src/db/data.dart';
import 'package:taiko_songs/src/irondb/iron.dart';

var logger = Logger('main');

Future<void> main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  await Iron.init();
  var data = DataSource();
  var list = data.getReleaseList();
  await for (var release in list) {
    var songList = await data.getSongList(release).toList();
    logger.info('${release.name} ${songList.length}');
  }
}
