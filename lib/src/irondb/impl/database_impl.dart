import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import '../../async/isolate_transformer.dart';
import '../database.dart';
import '../serialize.dart';

class DatabaseImpl implements Database {
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
    return await IsolateTransformer().convert(
        file,
        (e) => e
            .asyncExpand((file) => file.openRead())
            .transform(utf8.decoder)
            .join()
            .asStream()
            .map((str) => dataSerializer.deserialize<T>(str)));
  }

  @override
  Future<void> write<T>(String key, T? value) async {
    await folder.create(recursive: true);
    final file = File(path.join(folder.path, keySerializer.serialize(key)));
    if (value == null) {
      await file.delete();
      return;
    }
    await IsolateTransformer().run(value, (T value) async {
      final write = file.openWrite();
      final str = dataSerializer.serialize<T>(value);
      write.write(str);
      await write.flush();
      await write.close();
    });
  }

  @override
  Future<void> drop() async {
    await IsolateTransformer().run(folder, _deleteDirectory);
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
