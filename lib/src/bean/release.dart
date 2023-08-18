import 'song.dart';

class ReleaseItem {
  final String name;
  final String url;

  ReleaseItem(this.name, this.url);
}

class Release {
  final String name;
  final List<SongItem> songList;

  Release(this.name, this.songList);
}
