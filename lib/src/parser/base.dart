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
      if (value.startsWith('#')) {
        final iValue = int.parse(value.substring(1), radix: 16);
        return 0xff | iValue;
      }
      final htmlColor = htmlColorMap[value];
      if (htmlColor != null) {
        return 0xff | htmlColor;
      }
      // rgb(73, 213, 235)
      if (value.startsWith('rbg(')) {
        final rbgList = value.substring(4, value.length - 1).split(',');
        final rs = rbgList[0].trim();
        final bs = rbgList[1].trim();
        final gs = rbgList[2].trim();
        final ri = int.parse(rs) & 0xff;
        final bi = int.parse(bs) & 0xff;
        final gi = int.parse(gs) & 0xff;
        final rbg = (ri << (8 * 2)) | (bi << (8)) | gi;
        return 0xff | rbg;
      }
      return null;
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
    'silver': 0xc0c0c0,
    'magenta': 0xff00ff,
    'blue': 0x0000ff,
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
