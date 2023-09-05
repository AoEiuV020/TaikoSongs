import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:taiko_songs/src/irondb/database.dart';

class HtmlCache {
  final logger = Logger('HtmlCache');
  final Database db;

  HtmlCache(this.db);

  Future<String> request(String url) async {
    String? body = await db.read(url);
    if (body == null || body.isEmpty) {
      logger.info('download html: $url');
      var dio = Dio();
      var res = await dio.get(url);
      if (res.statusCode != 200) {
        throw StateError('http failed: ${res.statusCode}-${res.statusMessage}');
      }
      body = res.data!;
      await db.write(url, body);
    }
    return body!;
  }
}
