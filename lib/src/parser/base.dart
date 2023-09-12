import 'package:html/dom.dart';
import 'package:taiko_songs/src/parser/table.dart';

abstract class Parser {
  String getHref(Element e) {
    return e.attributes['href'] ?? '';
  }

  String getSrc(Element e) {
    return e.attributes['src'] ?? '';
  }

  int? getBackgroundColor(Element e) {
    final style = e.attributes['style'];
    if (style == null) {
      return null;
    }
    for (var entry in style.split(';')) {
      if (entry.isEmpty) {
        continue;
      }
      final list = entry.split(':');
      if (list.length < 2 || list[0].trim() != 'background-color') {
        continue;
      }
      final value = list[1].trim();
      if (value.startsWith('0x')) {
        final iValue = int.parse(value.substring(2), radix: 16);
        return iValue;
      }
      return htmlColorMap[value];
    }
    return null;
  }

  static final Map<String, int> htmlColorMap = {
    'cyan': 0x00ffff,
    'orange': 0xffa500,
    'darkgray': 0xa9a9a9,
    'lime': 0x00ff00,
    'gold': 0xffd700,
    'darkorchid': 0x9932cc,
    'orangered': 0xff4500,
  };

  String getAbsHref(String baseUrl, Element e) {
    var relativeLink = getHref(e);
    if (relativeLink.isEmpty) {
      return relativeLink;
    }
    var fullLink = Uri.parse(relativeLink).isAbsolute
        ? relativeLink
        : Uri.parse(baseUrl).resolve(relativeLink).toString();
    return fullLink;
  }

  Table parseTable(Element table) {
    return Table.fromElement(table);
  }
}
