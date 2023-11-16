import 'package:logging/logging.dart';

import '../irondb/database.dart';

class LineCache {
  final logger = Logger('LineCache');

  String getKey(String url) {
    return Uri.parse(url)
        .pathSegments
        .join('_')
        .replaceFirst('taiko-fumen_', '')
        .replaceFirst('作品_', '');
  }

  Future<List<T>?> readList<T>(
      Database db, String url, T Function(String line) fromLine) async {
    String key = getKey(url);
    String? body = await db.read(key);
    if (body == null) return null;
    return body
        .split('\n')
        .where((element) => element.isNotEmpty)
        .map((e) => fromLine(e))
        .toList();
  }

  Future<T?> read<T>(
      Database db, String url, T Function(String line) fromLine) async {
    String key = getKey(url);
    String? body = await db.read(key);
    if (body == null) return null;
    return fromLine(body);
  }

  Future<void> writeList<T>(Database db, String url, List<T>? data,
      String Function(T item) toLine) async {
    String key = getKey(url);
    if (data == null) return db.write(key, null);
    final objList = data.map((e) => toLine(e)).join('\n');
    await db.write(key, objList);
  }

  Future<void> write<T>(
      Database db, String url, T? data, String Function(T item) toLine) async {
    String key = getKey(url);
    if (data == null) return db.write(key, null);
    await db.write(key, toLine(data));
  }
}
