import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;

import '../database.dart';
import '../serialize.dart';

/// 针对flutter assets，按assets要求的文件名格式读写，
/// 重点在于assets不包含子目录，所以sub不能用子目录分级，多级sub改成文件名中多级下划线分割，
class DatabaseAssetsIO implements Database {
  final Directory folder;
  final KeySerializer keySerializer;
  final DataSerializer dataSerializer;
  final String prefix;

  DatabaseAssetsIO(
      this.folder, this.prefix, this.keySerializer, this.dataSerializer);

  /// assets不支持汉字等，会自动url编码，导致长度变三倍，
  /// 所以这里判断字节数≥15就使用md5摘要转16进制编码得到32字符，
  String resolve(String base, String sub) {
    final bytes = utf8.encode(sub);
    if (bytes.length >= 15) {
      sub = md5.convert(bytes).toString();
    } else {
      sub = Uri.encodeComponent(sub);
    }
    if (base.isEmpty) {
      return sub;
    }
    return '${base}_$sub';
  }

  /// 文件名和所在目录之间是斜杆分割，文件名内部的层级划分用下划线分割，
  String getAssetsKey(String key) {
    final filename = resolve(prefix, keySerializer.serialize(key));
    return path.join(folder.path, filename);
  }

  @override
  Database sub(String table) {
    return DatabaseAssetsIO(
        folder, resolve(prefix, table), keySerializer, dataSerializer);
  }

  @override
  Future<T?> read<T>(String key) async {
    final file = File(getAssetsKey(key));
    if (!await file.exists()) {
      return null;
    }
    final str = await file.readAsString();
    return dataSerializer.deserialize<T>(str);
  }

  @override
  Future<void> write<T>(String key, T? value) async {
    await folder.create(recursive: true);
    final file = File(getAssetsKey(key));
    if (value == null) {
      await file.delete();
      return;
    }
    await file.writeAsString(dataSerializer.serialize<T>(value));
  }

  @override
  Future<void> drop() async {
    if (!await folder.exists()) {
      return;
    }
    final pathPrefix = path.join(folder.path, prefix);
    await for (var file in folder.list()) {
      if (file.path.startsWith(pathPrefix)) {
        await file.delete();
      }
    }
  }
}
