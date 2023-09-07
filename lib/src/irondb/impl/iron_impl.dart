import 'dart:io';

import 'package:path/path.dart' as path;

import '../database.dart';
import '../iron.dart';
import '../serialize.dart';
import 'database_impl.dart';
import 'serialize_impl.dart';

class IronImpl implements IronInterface {
  String? base;
  KeySerializer? keySerializer;
  DataSerializer? dataSerializer;

  @override
  void init(
      {String? base,
      KeySerializer? keySerializer,
      DataSerializer? dataSerializer}) {
    this.base = base;
    this.keySerializer = keySerializer;
    this.dataSerializer = dataSerializer;
  }

  @override
  late Database db = _initDatabase();

  Database _initDatabase() {
    // kIsWeb
    if (const bool.fromEnvironment('dart.library.js_util')) {
      throw UnsupportedError('web not yet support!');
    }
    return DatabaseImpl(
        base ?? path.join(Directory.systemTemp.path, 'IronDB'),
        keySerializer ?? const ReplaceFileSeparator(),
        dataSerializer ?? const JsonDataSerializer());
  }
}
