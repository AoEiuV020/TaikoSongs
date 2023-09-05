import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:taiko_songs/src/irondb/iron.dart';

void main() {
  Iron.init(base: path.join(Directory.systemTemp.path, 'IronDBTest'));
  group('IronDB', () {
    test('string', () async {
      final db = await Iron.db.sub('string');
      await db.write('key', 'value');
      final value = await db.read('key');
      expect(value, 'value');
    });
    test('num', () async {
      final db = await Iron.db.sub('num');
      await db.write('int', 888);
      await db.write('double', 888.88);
      int vInt = await db.read('int');
      expect(vInt, 888);
      double vDouble = await db.read('double');
      expect(vDouble, 888.88);
    });
    test('list', () async {
      final db = await Iron.db.sub('list');
      await db.write('list', [8, 88, 888]);
      List<int> list = List<int>.from(await db.read('list'));
      expect(list, [8, 88, 888]);
    });
  });
}
