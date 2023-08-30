// ignore_for_file: avoid_print

import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:taiko_songs/src/bean/collection.dart';
import 'package:taiko_songs/src/cache/html_cache.dart';
import 'package:taiko_songs/src/parser/collection_parser.dart';

var logger = Logger('main');

Future<void> main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  var folder = Directory(path.join(Directory.systemTemp.path, 'taiko_songs'));
  var file = File(path.join(folder.path, 'collection.txt'));
  var collection = CollectionItem();
  var body = await HtmlCache().request(collection.url);
  var parser = CollectionParser();
  var list = parser.parseList(collection.url, body);
  var write = file.openWrite();
  int index = 0;
  await list.forEach((it) {
    logger.info("${++index} ${it.name} ${it.url}");
    write.writeln(it.name);
  });
  await write.close();
}
