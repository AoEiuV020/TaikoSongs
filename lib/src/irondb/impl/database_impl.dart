import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:taiko_songs/src/irondb/database.dart';

class DatabaseImpl implements Database {
  final Directory folder;

  DatabaseImpl._(this.folder);

  factory DatabaseImpl(String? base) {
    base ??= path.join(Directory.systemTemp.path, 'IronDB');
    return DatabaseImpl._(Directory(base));
  }

  @override
  Future<Database> sub(String table) async {
    final base = path.join(folder.path, table);
    return DatabaseImpl(base);
  }

  @override
  Future<T?> read<T>(String key) async {
    final file = File(path.join(folder.path, key));
    if (!await file.exists()) {
      return null;
    }
    final str = await file.readAsString();
    return jsonDecode(str);
  }

  @override
  Future<void> write<T>(String key, T? value) async {
    await folder.create(recursive: true);
    final file = File(path.join(folder.path, key));
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
