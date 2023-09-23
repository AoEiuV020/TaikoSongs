// ignore_for_file: avoid_print

import 'package:taiko_songs/src/db/data.dart';

/// 亚洲版中的歌曲名可能有斜杠/分割日文和中文，取出其中的中文，
Future<void> translateSongName(DataSource data) async {
  const url =
      'https://wikiwiki.jp/taiko-fumen/%E4%BD%9C%E5%93%81/%E6%96%B0AC%E3%82%A2%E3%82%B8%E3%82%A2%E7%89%88%28%E4%B8%AD%E5%9B%BD%E8%AA%9E%29';
  // https://gist.github.com/terrancesnyder/1345094
  final regex = RegExp(r'[ぁ-んァ-ン]');
  final Set<String> exists = {};
  await for (final release in data.getReleaseList()) {
    if (release.url != url) {
      continue;
    }
    await for (final song in data.getSongList(release)) {
      final name = song.name;
      if (exists.contains(name)) {
        continue;
      }
      exists.add(name);
      final slashIndex = name.indexOf('/');
      if (slashIndex == -1) {
        continue;
      }
      final jp = name.substring(0, slashIndex);
      final cn = name.substring(slashIndex + 1);
      if (regex.hasMatch(cn)) {
        continue;
      }
      print("$jp ==> $cn");
      print("$name ==> $cn");
      final subtitleList = song.subtitle.split('/');
      if (subtitleList.length != 2) {
        continue;
      }
      final subtitleJP = subtitleList[0];
      final subtitleCN = subtitleList[1].trim();
      if (subtitleJP.endsWith(' ') || subtitleCN.startsWith(' ')) {
        continue;
      }
      print("${subtitleJP.trim()} ==> $subtitleCN");
      print("${song.subtitle} ==> $subtitleCN");
    }
  }
}
