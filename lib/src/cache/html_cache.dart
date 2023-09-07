import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:taiko_songs/src/irondb/database.dart';

class HtmlCache {
  final logger = Logger('HtmlCache');
  late final dio = _createDio();

  Dio _createDio() {
    return Dio();
  }

  String getKey(String url) {
    return Uri.parse(url)
        .pathSegments
        .join('_')
        .replaceFirst('taiko-fumen_', '')
        .replaceFirst('作品_', '');
  }

  Future<String> request(
      Database db, String url, bool refresh, bool cacheOnly) async {
    String? body;
    String key = getKey(url);
    if (!refresh) {
      body = await db.read(key);
    }
    if (body == null || body.isEmpty) {
      if (!refresh && cacheOnly) {
        throw StateError("no cache: $key");
      }
      logger.info('download html: $url');
      final options = Options();
      final String? etag = await db.read('$key.etag');
      if (etag != null && etag.isNotEmpty) {
        logger.info('etag exists: $etag');
        options.headers = {
          HttpHeaders.ifNoneMatchHeader: etag,
        };
        options.validateStatus = (int? status) {
          return status == 200 || status == 304;
        };
      }
      var res = await dio.get(url, options: options);
      if (res.statusCode == 304) {
        if (refresh) {
          logger.info('not modified: $url');
          body = await db.read(key);
          return body!;
        }
        throw StateError('cache not found: $key');
      }
      if (res.statusCode != 200) {
        throw StateError('http failed: ${res.statusCode}-${res.statusMessage}');
      }
      body = res.data as String;
      await db.write(key, body);
      final String? resEtag = res.headers.value(HttpHeaders.etagHeader);
      if (resEtag != null && resEtag.isNotEmpty) {
        await db.write('$key.etag', resEtag);
      }
    } else {
      logger.info('read cache html: $url');
    }
    return body;
  }
}
