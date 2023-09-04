import 'package:html/parser.dart';
import 'package:taiko_songs/src/bean/difficulty.dart';
import 'package:taiko_songs/src/parser/base.dart';

class DifficultyParser extends Parser {
  Future<Difficulty> parseData(String baseUrl, String doc) async {
    var root = parse(doc);
    var table = parseTable(root.querySelector('#content > div > table')!);
    var img = root.querySelector('div#content > p > img')!;
    var imgUrl = getSrc(img);
    return Difficulty(table, 0, 0, '', imgUrl);
  }
}
