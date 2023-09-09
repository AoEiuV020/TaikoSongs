import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

import '../database.dart';
import '../serialize.dart';
import 'isolate_transformer.dart';
import 'serialize_impl.dart';

/// 针对flutter assets，按assets要求的文件名格式读取，不支持写入，
/// 重点在于assets不包含子目录，所以sub不能用子目录分级，多级sub改成文件名中多级下划线分割，
class DatabaseAssets implements Database {
  static final logger = Logger('DatabaseAssets');
  static final Map<String, dynamic> cacheMap = {};
  final String folder;
  final String prefix;
  final SubSerializer subSerializer = const AssetsFilenameSerializer();
  final KeySerializer keySerializer = const AssetsFilenameSerializer();
  final DataSerializer dataSerializer;

  DatabaseAssets(this.folder, this.prefix, this.dataSerializer);

  String resolve(String base, String sub) {
    if (base.isEmpty) {
      return sub;
    }
    return '${base}_$sub';
  }

  /// 文件名和所在目录之间是斜杆分割，文件名内部的层级划分用下划线分割，
  String getAssetsKey(String key) {
    final filename = resolve(prefix, keySerializer.serialize(key));
    return '$folder/$filename';
  }

  @override
  Database sub(String table) {
    table = subSerializer.serialize(table);
    return DatabaseAssets(folder, resolve(prefix, table), dataSerializer);
  }

  @override
  Future<T?> read<T>(String key) async {
    final assetsKey = getAssetsKey(key);
    T? cache = cacheMap[assetsKey] as T?;
    if (cache != null) {
      logger.info('use cache: $assetsKey');
      return cache;
    }
    final ByteData bundle;
    try {
      bundle = await rootBundle.load(assetsKey);
    } catch (e) {
      // The asset does not exist or has empty data.
      return null;
    }
    final ret = await IsolateTransformer<ByteData, T>().convert(
        bundle,
        (e) => e
            .asyncMap((data) => utf8.decode(data.buffer.asUint8List()))
            .map((str) => dataSerializer.deserialize<T>(str)));
    cacheMap[assetsKey] = ret;
    return ret;
  }

  @override
  Future<void> write<T>(String key, T? value) async {
    // This method cannot be supported.
  }

  @override
  Future<void> drop() async {
    // This method cannot be supported.
  }
}
