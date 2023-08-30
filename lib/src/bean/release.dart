import 'song.dart';

class ReleaseItem {
  final String name;
  final String url;

  ReleaseItem(this.name, this.url);

  factory ReleaseItem.fromUrl(String url) {
    var uri = Uri.parse(url);
    var name = uri.pathSegments.last;
    return ReleaseItem(name, url);
  }
}

class Release {
  final String name;
  final List<SongItem> songList;

  Release(this.name, this.songList);
}
