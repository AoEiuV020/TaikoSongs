// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:path/path.dart' as path;

Future<void> main(List<String> arguments) async {
  var url =
      'https://wikiwiki.jp/taiko-fumen/%E4%BD%9C%E5%93%81/NS2/%E5%A4%AA%E9%BC%93%E3%83%9F%E3%83%A5%E3%83%BC%E3%82%B8%E3%83%83%E3%82%AF%E3%83%91%E3%82%B9';
  var folder = Directory.systemTemp;
  folder = Directory(path.join(folder.path, 'taiko_songs'));
  await folder.create();
  var htmlFile = File(path.join(folder.path, 'ns2pass.html'));
  var songFile = File(path.join(folder.path, 'ns2pass.txt'));
  String body;
  if (!await htmlFile.exists()) {
    print('download html');
    var dio = Dio();
    var res = await dio.get(url);
    body = res.data;
    htmlFile.writeAsString(body);
  } else {
    print('read html');
    body = await htmlFile.readAsString();
  }
  var root = parse(body);
  var tableList = root.querySelectorAll('table');
  var write = songFile.openWrite();
  for (var table in tableList) {
    var thead = table.querySelector('thead');
    if (thead == null) {
      continue;
    }
    bool skip = true;
    for (var td in thead.querySelectorAll('tr > td')) {
      if (td.text.trim() == '曲名') {
        skip = false;
      }
    }
    if (skip) {
      continue;
    }
    var songList = table.querySelectorAll(
        'tbody > tr > td:nth-child(2)');
    for (var element in songList) {
      var nameElement = element.querySelector('strong');
      if (nameElement == null) {
        continue;
      }
      var name = nameElement.text;
      print(name);
      write.writeln(name);
    }
  }
  await write.close();
}
