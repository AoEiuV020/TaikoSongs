import 'package:logging/logging.dart';
import 'package:taiko_songs/src/bean/collection.dart';
import 'package:taiko_songs/src/bean/difficulty.dart';
import 'package:taiko_songs/src/bean/release.dart';
import 'package:taiko_songs/src/bean/song.dart';
import 'package:taiko_songs/src/cache/html_cache.dart';
import 'package:taiko_songs/src/irondb/database.dart';
import 'package:taiko_songs/src/irondb/impl/isolate_transformer.dart';
import 'package:taiko_songs/src/irondb/iron.dart';
import 'package:taiko_songs/src/parser/collection_parser.dart';
import 'package:taiko_songs/src/parser/difficulty_parser.dart';
import 'package:taiko_songs/src/parser/song_parser.dart';

class DataSource {
  static DataSource? _instance;

  DataSource._internal(this.db);

  factory DataSource() {
    _instance ??=
        DataSource._internal(Iron.mix([Iron.db, Iron.assetsDB]).sub('taiko'));
    return _instance!;
  }

  final Database db;
  final HtmlCache htmlCache = HtmlCache();
  final logger = Logger('DataSource');

  Stream<ReleaseItem> getReleaseList(
      {bool refresh = false, bool cacheOnly = false}) async* {
    var collection = CollectionItem();
    var body = await htmlCache.request(
        db.sub('collection'), collection.url, refresh, cacheOnly);
    yield* CollectionParser().parseList(collection.url, body);
  }

  Stream<SongItem> getSongList(ReleaseItem release,
      {bool refresh = false, bool cacheOnly = false}) async* {
    yield* IsolateTransformer<ReleaseItem, SongItem>().transform(
        Stream.value(release),
        (e) => e
            .asyncMap((event) => htmlCache.request(
                db.sub('release').sub(event.name),
                event.url,
                refresh,
                cacheOnly))
            .asyncExpand(
                (event) => SongParser().parseList(release.url, event)));
  }

  Future<Difficulty> getDifficulty(DifficultyItem difficultyItem,
      {bool refresh = false, bool cacheOnly = false}) async {
    var body = await htmlCache.request(db.sub('song').sub(difficultyItem.name),
        difficultyItem.url, refresh, cacheOnly);
    return await DifficultyParser().parseData(difficultyItem.url, body);
  }
}
