import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:taiko_songs/src/irondb/database.dart';

class JsonCache {
  final logger = Logger('JsonCache');

  String getKey(String url) {
    return Uri.parse(url)
        .pathSegments
        .join('_')
        .replaceFirst('taiko-fumen_', '')
        .replaceFirst('作品_', '');
  }

  Future<List<T>?> readList<T>(Database db, String url,
      T Function(Map<String, dynamic> json) fromJson) async {
    String key = getKey(url);
    String? body = await db.read(key);
    if (body == null) return null;
    return List<Map<String, dynamic>>.from(json.decode(body) as List)
        .map((e) => fromJson(e))
        .toList();
  }

  Future<T?> read<T>(Database db, String url,
      T Function(Map<String, dynamic> json) fromJson) async {
    String key = getKey(url);
    String? body = await db.read(key);
    if (body == null) return null;
    return fromJson(json.decode(body) as Map<String, dynamic>);
  }

  Future<void> writeList<T>(Database db, String url, List<T>? data,
      Map<String, dynamic> Function(T item) toJson) async {
    String key = getKey(url);
    if (data == null) return db.write(key, null);
    final objList = data.map((e) => toJson(e)).toList();
    await db.write(key, objList);
  }

  Future<void> write<T>(Database db, String url, T? data,
      Map<String, dynamic> Function(T item) toJson) async {
    String key = getKey(url);
    if (data == null) return db.write(key, null);
    await db.write(key, toJson(data));
  }
}
