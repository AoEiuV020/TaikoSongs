import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:taiko_songs/src/irondb/iron.dart';

void main() async {
  await Iron.init(base: path.join(Directory.systemTemp.path, 'IronDBTest'));
  group('IronDB', () {
    test('string', () async {
      final db = Iron.db.sub('string');
      String? value = 'value';
      // 这里参数可空非空里面都能识别到String,
      await db.write('key', value);
      // 这里必须指定<String>，巨坑，
      value = await db.read<String>('key');
      expect(value, 'value');

      String? value2 = await db.read('key');
      expect(value2, 'value');

      String value3 = 'value';
      // 这里参数可空非空里面都能识别到String,
      await db.write('key', value3);
      value3 = (await db.read<String>('key'))!;
      expect(value3, 'value');

      dynamic dValue = 'dValue';
      // 这里dynamic传入不会被识别到String,
      await db.write('dKey', dValue);
      // 这里必须是可空的String?里面才能识别到String,
      String? sValue = await db.read('dKey');
      expect(sValue, '"dValue"');
      // ignore: invalid_assignment
      String nValue = await db.read('dKey');
      expect(nValue, 'dValue');

      final sValue2 = await db.read<String>('dKey');
      expect(sValue2, '"dValue"');
    });
    test('num', () async {
      final db = Iron.db.sub('num');
      await db.write('int', 888);
      await db.write('double', 888.88);
      int? vInt = await db.read('int');
      expect(vInt, 888);
      double? vDouble = await db.read('double');
      expect(vDouble, 888.88);
    });
    test('list', () async {
      final db = Iron.db.sub('list');
      await db.write('list', [8, 88, 888]);
      // ignore: argument_type_not_assignable
      List<int> list = List<int>.from(await db.read('list'));
      expect(list, [8, 88, 888]);
      try {
        // ignore: unused_local_variable
        List<int>? list2 = await db.read('list');
        throw StateError('unreachable');
      } catch (e) {
        expect(e.toString(),
            "type 'List<dynamic>' is not a subtype of type 'List<int>' in type cast");
      }
    });
    test('KeySerializer', () async {
      final db = Iron.db.sub('key');
      const key = r'compileRegex("[/\\:|=?\";\\[\\],^]")';
      await db.write(key, 'test');
      final String? value = await db.read(key);
      expect(value, 'test');
    });
  });
}
