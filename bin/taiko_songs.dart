// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:path/path.dart' as path;

Future<void> main(List<String> arguments) async {
  var url = 'https://wikiwiki.jp/taiko-fumen/%E4%BD%9C%E5%93%81/NS2';
  var folder = Directory.systemTemp;
  folder = Directory(path.join(folder.path, 'taiko_songs'));
  await folder.create();
  var htmlFile = File(path.join(folder.path, 'ns2.html'));
  var songFile = File(path.join(folder.path, 'ns2.txt'));
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
  var songList = root.querySelectorAll(
      "#content > div > table > tbody > tr > td:nth-child(1)");
  var write = songFile.openWrite();
  for (var element in songList) {
    var nameElement = element.querySelector('strong');
    if (nameElement == null) {
      continue;
    }
    var name = nameElement.text;
    print(name);
    write.writeln(name);
  }
  await write.close();
}
