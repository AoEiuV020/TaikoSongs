// ignore_for_file: avoid_print, unused_local_variable

import 'package:logging/logging.dart';
import 'package:taiko_songs/src/db/data.dart';

var logger = Logger('main');

Future<void> main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  await DataSource.init();
  var data = DataSource();
  await refreshSongList(data);
}

Future<void> refreshSongList(DataSource data) async {
  var list = data.getReleaseList();
  var releaseIndex = 0;
  await for (var release in list) {
    ++releaseIndex;
    if (releaseIndex > 6) {
      break;
    }
    final songList = await data.getSongList(release, refresh: true).toList();
    logger.info('$releaseIndex ${release.name} ${songList.length}');
  }
  logger.info('release count: $releaseIndex');
}
