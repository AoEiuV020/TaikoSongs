import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:taiko_songs/src/irondb/database.dart';
import 'package:taiko_songs/src/irondb/impl/serialize_impl.dart';

import '../serialize.dart';

class DatabaseImpl extends Database {
  final Directory folder;
  final KeySerializer keySerializer;

  DatabaseImpl._(this.folder, this.keySerializer);

  factory DatabaseImpl(String? base, KeySerializer? keySerializer) {
    base ??= path.join(Directory.systemTemp.path, 'IronDB');
    keySerializer ??= ReplaceFileSeparator();
    return DatabaseImpl._(Directory(base), keySerializer);
  }

  @override
  Database sub(String table) {
    final base = path.join(folder.path, table);
    return DatabaseImpl(base, keySerializer);
  }

  @override
  Future<T?> read<T>(String key) async {
    final file = File(path.join(folder.path, keySerializer.serialize(key)));
    if (!await file.exists()) {
      return null;
    }
    if (T == String) {
      return await file.readAsString() as T;
    }
    final str = await file.readAsString();
    return jsonDecode(str);
  }

  @override
  Future<void> write<T>(String key, T? value) async {
    await folder.create(recursive: true);
    final file = File(path.join(folder.path, keySerializer.serialize(key)));
    if (value == null) {
      await file.delete();
      return;
    }
    if (T == String) {
      await file.writeAsString(value as String);
      return;
    }
    await file.writeAsString(jsonEncode(value));
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
