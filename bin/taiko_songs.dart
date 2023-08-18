// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:taiko_songs/src/bean/song.dart';
import 'package:taiko_songs/src/calc/calculator.dart';

Future<void> main(List<String> arguments) async {
  Calculator<Song> calc = SongCalculator(CalcAction.plus, load("ns1"))
      .and(SongCalculator(CalcAction.minus, load("ns2")))
      .and(SongCalculator(CalcAction.minus, load("ns2pass")));
  var result = calc.calc(const Stream.empty());
  int index = 0;
  await for (var song in result) {
    print('${++index} ${song.name}');
  }
}

Stream<Song> load(String name) async* {
  var folder = Directory.systemTemp;
  folder = Directory(path.join(folder.path, 'taiko_songs'));
  await folder.create();
  var file = File(path.join(folder.path, "$name.txt"));
  var lines =
      file.openRead().transform(utf8.decoder).transform(const LineSplitter());
  yield* lines
      .where((event) => event.trim().isNotEmpty)
      .map((event) => Song(event));
}
