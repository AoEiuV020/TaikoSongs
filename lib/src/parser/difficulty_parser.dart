import 'package:html/parser.dart';
import 'package:taiko_songs/src/bean/difficulty.dart';
import 'package:taiko_songs/src/parser/base.dart';

class DifficultyParser extends Parser {
  Future<Difficulty> parseData(String baseUrl, String doc) async {
    var root = parse(doc);
    // https://wikiwiki.jp/taiko-fumen/%E5%8F%8E%E9%8C%B2%E6%9B%B2/%E3%81%8B%E3%82%93%E3%81%9F%E3%82%93/Dreadnought
    // https://cdn.wikiwiki.jp/to/w/taiko-fumen/%E5%8F%8E%E9%8C%B2%E6%9B%B2/%E3%81%8B%E3%82%93%E3%81%9F%E3%82%93/Dreadnought/::ref/%E5%BC%A9%E7%B0%A1.png?rev=e7c840f50e5b6e819f523c2ab967a45c&t=20230222160437
    // https://cdn.wikiwiki.jp/to/w/taiko-fumen/%3AHeader/::ref/FumenWiki_header.png.webp?rev=94e4fdf897d61f56e3366a97b1deba78&t=20230627001908
    final prefix = baseUrl.replaceFirst(
        'https://wikiwiki.jp/', 'https://cdn.wikiwiki.jp/to/w/');
    var imgUrl = root
        .querySelectorAll('div#content img')
        .map((e) => getSrc(e))
        .firstWhere((element) => element.startsWith(prefix));
    return Difficulty(0, 0, '', imgUrl);
  }
}
