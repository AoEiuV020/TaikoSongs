import 'dart:convert';

import 'package:iron_db/iron_db.dart';

import '../async/isolate_transformer.dart';

class TranslatedSource {
  final Database _db;

  late final Future<Map<String, String>> _translatedMap = _initTranslatedMap();

  TranslatedSource(this._db);

  Future<Map<String, String>> _initTranslatedMap() async {
    final transformer = IsolateTransformer();
    final Map<String, String> resultMap = {};
    await _loadAssets(transformer, resultMap, 'release_name.txt');
    await _loadAssets(transformer, resultMap, 'song_name_ps4.txt');
    await _loadAssets(transformer, resultMap, 'song_name_slash.txt');
    await _loadAssets(transformer, resultMap, 'song_name_ns2.txt');
    await _loadAssets(transformer, resultMap, 'other.txt');
    return resultMap;
  }

  Future<void> _loadAssets(IsolateTransformer transformer,
      Map<String, String> resultMap, String filename) async {
    final data = await _db.read<String>(filename);
    if (data == null) {
      return;
    }
    final stream = transformer.transform(
        Stream.value(data),
        (e) => e
            .transform(const LineSplitter())
            .where((event) => event.isNotEmpty)
            .where((event) => !event.startsWith('//'))
            .map((event) => event.split(' ==> '))
            .where((event) => event.length > 1)
            .map((event) => MapEntry(event[0], event[1])));
    await for (final entry in stream) {
      resultMap[entry.key] = entry.value;
    }
  }

  Future<String?> getTranslated(String text) async {
    final map = await _translatedMap;
    return map[text];
  }
}
