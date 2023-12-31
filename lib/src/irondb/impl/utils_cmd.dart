import 'dart:io';

import 'package:path/path.dart' as path;

import '../database.dart';
import '../serialize.dart';
import 'database_assets_io.dart';
import 'database_impl.dart';

// linux: /tmp
Future<String> getDefaultBase() async {
  final folder = Directory.systemTemp;
  return path.join(folder.path, 'IronDB');
}

Database getDefaultDatabase(String base, KeySerializer keySerializer,
        DataSerializer dataSerializer) =>
    DatabaseImpl(base, keySerializer, dataSerializer);

Database getDefaultAssetsDatabase(
        String assetsBase, DataSerializer dataSerializer) =>
    DatabaseAssetsIO(Directory(assetsBase), '', dataSerializer);
