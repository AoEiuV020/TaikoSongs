// ignore_for_file: avoid_print, unused_local_variable

import 'package:logging/logging.dart';
import 'package:taiko_songs/src/bean/song.dart';
import 'package:taiko_songs/src/db/data.dart';
import 'package:taiko_songs/src/irondb/iron.dart';

import 'translate_name_huali.dart';

var logger = Logger('main');

Future<void> main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  await Iron.init();
  var data = DataSource();
  await translateSongName(data);
}

Future<void> printSongName(DataSource data) async {
  var list = data.getReleaseList();
  var releaseIndex = 0;
  var songIndex = 0;
  await for (var release in list) {
    ++releaseIndex;
    if (release.name != '太鼓の達人 ドンダフルフェスティバル（NS2）') {
      continue;
    }
    await for (var song in data.getSongList(release)) {
      ++songIndex;
      logger.info('${songIndex.toString().padLeft(4, ' ')} ${song.name}');
    }
    logger.info('song count: $songIndex');
  }
  logger.info('release count: $releaseIndex');
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

Future<void> printReleaseName(DataSource data) async {
  var list = data.getReleaseList();
  var releaseIndex = 0;
  await for (var release in list) {
    ++releaseIndex;
    logger.info('${releaseIndex.toString().padLeft(2, ' ')} ${release.name}');
  }
  logger.info('release count: $releaseIndex');
}

Future<void> printSongCategory(DataSource data) async {
  var list = data.getReleaseList();
  var releaseIndex = 0;
  await for (var release in list) {
    ++releaseIndex;
    final songList = await data.getSongList(release).toList();
    final Map<String, List<SongItem>> categoryMap = {};
    for (var song in songList) {
      var list = categoryMap[song.category];
      if (list == null) {
        list = [];
        categoryMap[song.category] = list;
      }
      list.add(song);
    }
    final categoryString = categoryMap
        .map((key, value) => MapEntry(key,
            '$key#${value[0].categoryColor?.toRadixString(16).padLeft(6, '0')} ${value.length}'))
        .values
        .join(', ');
    logger.info(
        '$releaseIndex ${release.name} ${songList.length} $categoryString');
  }
  logger.info('release count: $releaseIndex');
}

Future<void> printSongCount(DataSource data) async {
  var list = data.getReleaseList();
  var releaseIndex = 0;
  await for (var release in list) {
    ++releaseIndex;
    final songList = await data.getSongList(release).toList();
    logger.info('$releaseIndex ${release.name} ${songList.length}');
  }
  logger.info('release count: $releaseIndex');
}
