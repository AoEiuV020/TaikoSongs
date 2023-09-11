import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import '../../async/isolate_transformer.dart';
import '../database.dart';
import '../serialize.dart';
import 'serialize_impl.dart';

/// 针对flutter assets，按assets要求的文件名格式读写，
/// 重点在于assets不包含子目录，所以sub不能用子目录分级，多级sub改成文件名中多级下划线分割，
class DatabaseAssetsIO implements Database {
  final Directory folder;
  final SubSerializer subSerializer = const AssetsFilenameSerializer();
  final KeySerializer keySerializer = const AssetsFilenameSerializer();
  final DataSerializer dataSerializer;
  final String prefix;

  DatabaseAssetsIO(this.folder, this.prefix, this.dataSerializer);

  String resolve(String base, String sub) {
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
    table = subSerializer.serialize(table);
    return DatabaseAssetsIO(folder, resolve(prefix, table), dataSerializer);
  }

  @override
  Future<T?> read<T>(String key) async {
    final file = File(getAssetsKey(key));
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
    final file = File(getAssetsKey(key));
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
    await IsolateTransformer().run(folder, (folder) async {
      if (!await folder.exists()) {
        return;
      }
      final pathPrefix = path.join(folder.path, prefix);
      await for (var file in folder.list()) {
        if (file.path.startsWith(pathPrefix)) {
          await file.delete();
        }
      }
    });
  }
}
