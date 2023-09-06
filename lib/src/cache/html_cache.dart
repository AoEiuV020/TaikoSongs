import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:taiko_songs/src/irondb/database.dart';

class HtmlCache {
  final logger = Logger('HtmlCache');

  Future<String> request(
      Database db, String url, bool refresh, bool cacheOnly) async {
    String? body;
    if (!refresh) {
      body = await db.read(url);
    }
    if (body == null || body.isEmpty) {
      if (!refresh && cacheOnly) {
        throw StateError("no cache: $url");
      }
      logger.info('download html: $url');
      var dio = Dio();
      var res = await dio.get(url);
      if (res.statusCode != 200) {
        throw StateError('http failed: ${res.statusCode}-${res.statusMessage}');
      }
      body = res.data!;
      await db.write(url, body);
    } else {
      logger.info('read cache html: $url');
    }
    return body!;
  }
}
