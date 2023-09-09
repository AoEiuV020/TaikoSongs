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

  factory DatabaseImpl(String base, KeySerializer keySerializer, DataSerializer dataSerializer) {
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
    return await IsolateTransformer<File, T>().convert(
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
    final write = file.openWrite();
    await write.addStream(IsolateTransformer<T, List<int>>().transform(
        Stream.value(value),
        (e) => e
            .map((value) => dataSerializer.serialize<T>(value))
            .transform(utf8.encoder)));
    await write.flush();
    await write.close();
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
