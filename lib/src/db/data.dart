import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:taiko_songs/src/bean/collection.dart';
import 'package:taiko_songs/src/bean/release.dart';
import 'package:taiko_songs/src/cache/html_cache.dart';
import 'package:taiko_songs/src/parser/collection_parser.dart';

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

  Future<Directory> getCacheFolder(String name) async {
    await folder.create();
    return Directory(path.join(folder.path, name));
  }
}
