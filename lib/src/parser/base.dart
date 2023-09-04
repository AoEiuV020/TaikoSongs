import 'package:html/dom.dart';
import 'package:taiko_songs/src/parser/table.dart';

abstract class Parser {
  String getHref(Element e) {
    return e.attributes['href'] ?? '';
  }

  String getSrc(Element e) {
    return e.attributes['src'] ?? '';
  }

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
