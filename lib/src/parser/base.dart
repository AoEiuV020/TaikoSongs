import 'package:html/dom.dart';

abstract class Parser {
  String getHref(Element e) {
    return e.attributes['href'] ?? '';
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
}
