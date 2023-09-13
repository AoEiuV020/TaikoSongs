import 'package:html/parser.dart';
import 'package:taiko_songs/src/bean/release.dart';
import 'package:taiko_songs/src/parser/base.dart';

class CollectionParser extends Parser {
  Stream<ReleaseItem> parseList(String baseUrl, String doc) {
    var root = parse(doc);
    // 現行作品
    var aList1 = root.querySelectorAll('#content table > tbody > tr > td > a');
    var aList2 = root.querySelectorAll('#content ul li a');
    var urlPrefix = 'https://wikiwiki.jp/taiko-fumen/%E4%BD%9C%E5%93%81/';

    final Set<String> existsSet = {};
    return Stream.fromIterable(aList1 + aList2)
        .map((event) => ReleaseItem(event.text, getAbsHref(baseUrl, event)))
        .where((event) => event.url.startsWith(urlPrefix))
        .map((event) => ['ENG', '中文', '北米版', '亜州版', '韓国版'].contains(event.name)
            ? ReleaseItem.fromUrl(event.url)
            : event)
        .where((event) => existsSet.add(event.url))
        .distinct((a, b) => a.url == b.url);
  }
}
