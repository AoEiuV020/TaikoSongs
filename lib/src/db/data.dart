import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:taiko_songs/src/bean/collection.dart';
import 'package:taiko_songs/src/bean/release.dart';
import 'package:taiko_songs/src/bean/song.dart';
import 'package:taiko_songs/src/cache/html_cache.dart';
import 'package:taiko_songs/src/parser/collection_parser.dart';
import 'package:taiko_songs/src/parser/song_parser.dart';

class DataSource {
  final Directory folder;
  final logger = Logger('DataSource');

  DataSource(this.folder);

  Stream<ReleaseItem> getReleaseList() async* {
    var collection = CollectionItem();
    var body = await HtmlCache(await getCacheFolder('collection'))
        .request(collection.url);
    yield* CollectionParser().parseList(collection.url, body);
  }

  Stream<SongItem> getSongList(ReleaseItem release) async* {
    var body = await HtmlCache(await getCacheFolder(release.name))
        .request(release.url);
    yield* SongParser().parseList(body);
  }

  Future<Directory> getCacheFolder(String name) async {
    await folder.create();
    return Directory(path.join(folder.path, name));
  }
}
