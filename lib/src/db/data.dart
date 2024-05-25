import 'package:iron_db/iron_db.dart';
import 'package:logging/logging.dart';

import '../async/isolate_transformer.dart';
import '../bean/collection.dart';
import '../bean/difficulty.dart';
import '../bean/release.dart';
import '../bean/song.dart';
import '../cache/html_cache.dart';
import '../cache/line_cache.dart';
import '../parser/collection_parser.dart';
import '../parser/difficulty_parser.dart';
import '../parser/song_parser.dart';
import 'translated.dart';

class DataSource {
  static DataSource? _instance;

  static Future<void> init() => Iron.init();

  DataSource._internal();

  factory DataSource() {
    _instance ??= DataSource._internal();
    return _instance!;
  }

  final lineDB = Iron.mix([
    Iron.db.sub('line'),
    Iron.assetsDB('assets/line'),
  ]).sub('taiko');
  final htmlDB = Iron.mix([
    Iron.db.sub('html'),
    Iron.assetsDB('assets/html'),
  ]).sub('taiko');
  final translatedSource = TranslatedSource(Iron.assetsDB('assets/translate'));
  final htmlCache = HtmlCache();
  final lineCache = LineCache();
  final logger = Logger('DataSource');

  Stream<ReleaseItem> getReleaseList(
      {bool refresh = false, bool cacheOnly = false}) async* {
    var collection = CollectionItem();
    if (!refresh) {
      final cache = await lineCache.readList(lineDB.sub('collection'),
          collection.url, (line) => ReleaseItem.fromLine(collection.url, line));
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
    await lineCache.writeList(lineDB.sub('collection'), collection.url, data,
        (item) => item.toLine(collection.url));
  }

  Stream<SongItem> getSongList(ReleaseItem release,
      {bool refresh = false, bool cacheOnly = false}) async* {
    if (!refresh) {
      final cache = await lineCache.readList(lineDB.sub('release'), release.url,
          (line) => SongItem.fromLine(line));
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
    await lineCache.writeList(
        lineDB.sub('release'), release.url, data, (item) => item.toLine());
  }

  Future<Difficulty> getDifficulty(DifficultyItem difficultyItem,
      {bool refresh = false, bool cacheOnly = false}) async {
    if (!refresh) {
      final cache = await lineCache.read(lineDB.sub('song'), difficultyItem.url,
          (line) => Difficulty.fromLine(line));
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
    await lineCache.write(
        lineDB.sub('song'), difficultyItem.url, ret, (item) => item.toLine());
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
