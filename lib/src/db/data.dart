import 'package:logging/logging.dart';
import 'package:taiko_songs/src/async/isolate_transformer.dart';
import 'package:taiko_songs/src/bean/collection.dart';
import 'package:taiko_songs/src/bean/difficulty.dart';
import 'package:taiko_songs/src/bean/release.dart';
import 'package:taiko_songs/src/bean/song.dart';
import 'package:taiko_songs/src/cache/html_cache.dart';
import 'package:taiko_songs/src/db/translated.dart';
import 'package:taiko_songs/src/irondb/database.dart';
import 'package:taiko_songs/src/irondb/iron.dart';
import 'package:taiko_songs/src/parser/collection_parser.dart';
import 'package:taiko_songs/src/parser/difficulty_parser.dart';
import 'package:taiko_songs/src/parser/song_parser.dart';

class DataSource {
  static DataSource? _instance;

  DataSource._internal();

  factory DataSource() {
    _instance ??= DataSource._internal();
    return _instance!;
  }

  final Database db = Iron.mix([
    Iron.db,
    Iron.assetsDB(),
  ]).sub('taiko');
  final TranslatedSource translatedSource =
      TranslatedSource(Iron.assetsDB('assets/translate'));
  final HtmlCache htmlCache = HtmlCache();
  final logger = Logger('DataSource');

  Stream<ReleaseItem> getReleaseList(
      {bool refresh = false, bool cacheOnly = false}) async* {
    var collection = CollectionItem();
    yield* IsolateTransformer().transform(
        Stream.fromFuture(htmlCache.request(
            db.sub('collection'), collection.url, refresh, cacheOnly)),
        (e) => e.asyncExpand(
            (body) => CollectionParser().parseList(collection.url, body)));
  }

  Stream<SongItem> getSongList(ReleaseItem release,
      {bool refresh = false, bool cacheOnly = false}) async* {
    yield* IsolateTransformer().transform(
        Stream.fromFuture(htmlCache.request(db.sub('release').sub(release.name),
            release.url, refresh, cacheOnly)),
        (e) =>
            e.asyncExpand((body) => SongParser().parseList(release.url, body)));
  }

  Future<Difficulty> getDifficulty(DifficultyItem difficultyItem,
      {bool refresh = false, bool cacheOnly = false}) async {
    return await IsolateTransformer()
        .transform(
            Stream.fromFuture(htmlCache.request(
                db.sub('song').sub(difficultyItem.name),
                difficultyItem.url,
                refresh,
                cacheOnly)),
            (e) => e.asyncMap((body) =>
                DifficultyParser().parseData(difficultyItem.url, body)))
        .first;
  }

  Future<String?> getTranslated(String text) =>
      translatedSource.getTranslated(text);

  Stream<ReleaseItem> search(String keyword) async* {
    final keywordList = keyword.split(' ');
    final releaseStream = getReleaseList();
    await for (final release in releaseStream) {
      var nameMatch = true;
      for (final key in keywordList) {
        if (!release.name.contains(key)) {
          nameMatch = false;
        }
      }
      if (nameMatch) {
        yield release;
        continue;
      }
      final songStream = searchSong(release, keyword);
      if (await songStream.isEmpty) {
        continue;
      }
      yield release;
    }
  }

  Stream<SongItem> searchSong(ReleaseItem release, String keyword) {
    final keywordList = keyword.split(' ');
    return getSongList(release).where((song) {
      for (final key in keywordList) {
        if (!song.name.contains(key) && !song.subtitle.contains(key)) {
          return false;
        }
      }
      return true;
    });
  }
}
