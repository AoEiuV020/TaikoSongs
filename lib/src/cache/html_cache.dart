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

  Future<String> request(
      Database db, String url, bool refresh, bool cacheOnly) async {
    String? body;
    if (!refresh) {
      body = await db.readString(url);
    }
    if (body == null || body.isEmpty) {
      if (!refresh && cacheOnly) {
        throw StateError("no cache: $url");
      }
      logger.info('download html: $url');
      final options = Options();
      final etag = await db.readString('$url.etag');
      if (etag != null && etag.isNotEmpty) {
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
          body = await db.readString(url);
          return body!;
        }
        throw StateError('cache not found: $url');
      }
      if (res.statusCode != 200) {
        throw StateError('http failed: ${res.statusCode}-${res.statusMessage}');
      }
      body = res.data!;
      await db.writeString(url, body);
      final resEtag = res.headers.value(HttpHeaders.etagHeader);
      if (resEtag != null && resEtag.isNotEmpty) {
        await db.writeString('$url.etag', resEtag);
      }
    } else {
      logger.info('read cache html: $url');
    }
    return body!;
  }
}
