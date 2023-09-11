import 'package:json_annotation/json_annotation.dart';

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
}
