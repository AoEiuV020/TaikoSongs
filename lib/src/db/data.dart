import 'package:logging/logging.dart';
import 'package:taiko_songs/src/async/isolate_transformer.dart';
import 'package:taiko_songs/src/bean/collection.dart';
import 'package:taiko_songs/src/bean/difficulty.dart';
import 'package:taiko_songs/src/bean/release.dart';
import 'package:taiko_songs/src/bean/song.dart';
import 'package:taiko_songs/src/cache/html_cache.dart';
import 'package:taiko_songs/src/cache/json_cache.dart';
import 'package:taiko_songs/src/db/translated.dart';
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

  final jsonDB = Iron.mix([
    Iron.db.sub('json'),
    Iron.assetsDB('assets/json'),
  ]).sub('taiko');
  final htmlDB = Iron.mix([
    Iron.db.sub('html'),
    Iron.assetsDB('assets/html'),
  ]).sub('taiko');
  final translatedSource = TranslatedSource(Iron.assetsDB('assets/translate'));
  final htmlCache = HtmlCache();
  final jsonCache = JsonCache();
  final logger = Logger('DataSource');

  Stream<ReleaseItem> getReleaseList(
      {bool refresh = false, bool cacheOnly = false}) async* {
    var collection = CollectionItem();
    if (!refresh) {
      final cache = await jsonCache.readList(jsonDB.sub('collection'),
          collection.url, (json) => ReleaseItem.fromJson(json));
      if (cache != null) {
        yield* Stream.fromIterable(cache);
        return;
      }
    }
    final stream = IsolateTransformer().transform(
        Stream.fromFuture(htmlCache.request(
            htmlDB.sub('collection'), collection.url, refresh, cacheOnly)),
        (e) => e.asyncExpand(
            (body) => CollectionParser().parseList(collection.url, body)));
    final List<ReleaseItem> data = [];
    await for (final item in stream) {
      yield item;
      data.add(item);
    }
    await jsonCache.writeList(jsonDB.sub('collection'), collection.url, data,
        (item) => item.toJson());
  }

  Stream<SongItem> getSongList(ReleaseItem release,
      {bool refresh = false, bool cacheOnly = false}) async* {
    if (!refresh) {
      final cache = await jsonCache.readList(jsonDB.sub('release'), release.url,
          (json) => SongItem.fromJson(json));
      if (cache != null) {
        yield* Stream.fromIterable(cache);
        return;
      }
    }
    final stream = IsolateTransformer().transform(
        Stream.fromFuture(htmlCache.request(
            htmlDB.sub('release').sub(release.name),
            release.url,
            refresh,
            cacheOnly)),
        (e) =>
            e.asyncExpand((body) => SongParser().parseList(release.url, body)));
    final List<SongItem> data = [];
    await for (final item in stream) {
      yield item;
      data.add(item);
    }
    await jsonCache.writeList(
        jsonDB.sub('release'), release.url, data, (item) => item.toJson());
  }

  Future<Difficulty> getDifficulty(DifficultyItem difficultyItem,
      {bool refresh = false, bool cacheOnly = false}) async {
    if (!refresh) {
      final cache = await jsonCache.read(jsonDB.sub('song'), difficultyItem.url,
          (json) => Difficulty.fromJson(json));
      if (cache != null) {
        return cache;
      }
    }
    final ret = await IsolateTransformer()
        .transform(
            Stream.fromFuture(htmlCache.request(
                htmlDB.sub('song').sub(difficultyItem.name),
                difficultyItem.url,
                refresh,
                cacheOnly)),
            (e) => e.asyncMap((body) =>
                DifficultyParser().parseData(difficultyItem.url, body)))
        .first;
    await jsonCache.write(
        jsonDB.sub('song'), difficultyItem.url, ret, (item) => item.toJson());
    return ret;
  }

  Future<String?> getTranslated(String text) =>
      translatedSource.getTranslated(text);

  Future<bool> textContains(String text, String key) async {
    String textLow = text.toLowerCase();
    String keyLow = key.toLowerCase();
    if (textLow.contains(keyLow)) {
      return true;
    }
    final translated = await getTranslated(text);
    return translated != null && translated.toLowerCase().contains(keyLow);
  }

  Stream<ReleaseItem> search(String keyword) async* {
    final keywordList = keyword.split(' ');
    final releaseStream = getReleaseList();
    await for (final release in releaseStream) {
      var nameMatch = true;
      for (final key in keywordList) {
        if (!await textContains(release.name, key)) {
          nameMatch = false;
          break;
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

  Stream<SongItem> searchSong(ReleaseItem release, String keyword) async* {
    final keywordList = keyword.split(' ');
    final songStream = getSongList(release);
    await for (final song in songStream) {
      var nameMatch = true;
      for (final key in keywordList) {
        if (!await textContains(song.name, key) &&
            !await textContains(song.subtitle, key)) {
          nameMatch = false;
          break;
        }
      }
      if (nameMatch) {
        yield song;
      }
    }
  }
}
