import 'dart:io';

import 'package:path/path.dart' as path;

import '../database.dart';
import '../serialize.dart';

class DatabaseImpl extends Database {
  final Directory folder;
  final KeySerializer keySerializer;
  final DataSerializer dataSerializer;

  DatabaseImpl._(this.folder, this.keySerializer, this.dataSerializer);

  factory DatabaseImpl(
      String base, KeySerializer keySerializer, DataSerializer dataSerializer) {
    return DatabaseImpl._(Directory(base), keySerializer, dataSerializer);
  }

  @override
  Database sub(String table) {
    final base = path.join(folder.path, table);
    return DatabaseImpl(base, keySerializer, dataSerializer);
  }

  @override
  Future<T?> read<T>(String key) async {
    final file = File(path.join(folder.path, keySerializer.serialize(key)));
    if (!await file.exists()) {
      return null;
    }
    final str = await file.readAsString();
    return dataSerializer.deserialize<T>(str);
  }

  @override
  Future<void> write<T>(String key, T? value) async {
    await folder.create(recursive: true);
    final file = File(path.join(folder.path, keySerializer.serialize(key)));
    if (value == null) {
      await file.delete();
      return;
    }
    await file.writeAsString(dataSerializer.serialize<T>(value));
  }

  @override
  Future<void> drop() async {
    _deleteDirectory(folder);
  }

  Future<void> _deleteDirectory(Directory directory) async {
    if (!await directory.exists()) {
      return;
    }
    await for (var entity in directory.list()) {
      if (entity is File) {
        await entity.delete(); // 删除文件
      } else if (entity is Directory) {
        await _deleteDirectory(entity); // 递归删除子目录
      }
    }
    await directory.delete(); // 删除当前目录
  }
}
