import 'package:html/parser.dart';
import 'package:taiko_songs/src/bean/release.dart';
import 'package:taiko_songs/src/parser/base.dart';

class CollectionParser extends Parser {
  Stream<ReleaseItem> parseList(String baseUrl, String doc) {
    var root = parse(doc);
    var aList = root.querySelectorAll('#content ul li a');
    var urlPrefix = 'https://wikiwiki.jp/taiko-fumen/%E4%BD%9C%E5%93%81/';
    return Stream.fromIterable(aList)
        .map((event) => ReleaseItem(event.text, getAbsHref(baseUrl, event)))
        .where((event) => event.url.startsWith(urlPrefix))
        .map((event) => ['ENG', '中文', '北米版', '亜州版', '韓国版'].contains(event.name)
            ? ReleaseItem.fromUrl(event.url)
            : event)
        .distinct((a, b) => a.url == b.url);
  }
}
