import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:taiko_songs/src/bean/collection.dart';
import 'package:taiko_songs/src/bean/difficulty.dart';
import 'package:taiko_songs/src/bean/release.dart';
import 'package:taiko_songs/src/bean/song.dart';
import 'package:taiko_songs/src/cache/html_cache.dart';
import 'package:taiko_songs/src/parser/collection_parser.dart';
import 'package:taiko_songs/src/parser/difficulty_parser.dart';
import 'package:taiko_songs/src/parser/song_parser.dart';

class DataSource {
  static DataSource? _instance;

  DataSource._internal(this.folder);

  factory DataSource() {
    if (_instance == null) {
      var folder =
          Directory(path.join(Directory.systemTemp.path, 'taiko_songs'));
      _instance = DataSource._internal(folder);
    }
    return _instance!;
  }

  final Directory folder;
  final logger = Logger('DataSource');

  Stream<ReleaseItem> getReleaseList() async* {
    var collection = CollectionItem();
    var body = await HtmlCache(await getCacheFolder('collection'))
        .request(collection.url);
    yield* CollectionParser().parseList(collection.url, body);
  }

  Stream<SongItem> getSongList(ReleaseItem release) async* {
    var body = await HtmlCache(await getCacheFolder(release.name))
        .request(release.url);
    yield* SongParser().parseList(release.url, body);
  }

  Future<Difficulty> getDifficulty(DifficultyItem difficultyItem) async {
    var body = await HtmlCache(await getCacheFolder('song'))
        .request(difficultyItem.url);
    return await DifficultyParser().parseData(difficultyItem.url, body);
  }

  Future<Directory> getCacheFolder(String name) async {
    await folder.create();
    return Directory(path.join(folder.path, name));
  }
}
