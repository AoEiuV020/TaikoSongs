import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;

class HtmlCache {
  final logger = Logger('HtmlCache');
  final Directory folder;

  HtmlCache(this.folder);

  Future<String> request(String url) async {
    await folder.create();
    var md5String = md5.convert(utf8.encode(url)).toString();
    var htmlFile = File(path.join(folder.path, md5String));
    String body;
    if (!await htmlFile.exists() || await htmlFile.length() == 0) {
      logger.info('download html: $url');
      var dio = Dio();
      var res = await dio.get(url);
      if (res.statusCode != 200) {
        throw StateError('http failed: ${res.statusCode}-${res.statusMessage}');
      }
      body = res.data;
      htmlFile.writeAsString(body);
    } else {
      logger.info('read html: $url');
      body = await htmlFile.readAsString();
    }
    return body;
  }
}
