import 'package:json_annotation/json_annotation.dart';

import '../util/serialize.dart';

part 'release.g.dart';

@JsonSerializable()
class ReleaseItem {
  final String name;
  final String url;

  ReleaseItem(this.name, this.url);

  factory ReleaseItem.fromUrl(String url) {
    var uri = Uri.parse(url);
    var name = uri.pathSegments.last;
    return ReleaseItem(name, url);
  }

  factory ReleaseItem.fromJson(Map<String, dynamic> json) =>
      _$ReleaseItemFromJson(json);

  Map<String, dynamic> toJson() => _$ReleaseItemToJson(this);

  factory ReleaseItem.fromLine(String base, String line) {
    final strList = line.split(',');
    final name = strList[0];
    final url = BeanSerialize.deserialize(base, strList[1]);
    return ReleaseItem(name, url);
  }

  String toLine(String base) =>
      [name, BeanSerialize.serialize(base, url)].join(',');
}
