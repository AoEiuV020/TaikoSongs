import 'package:flutter_test/flutter_test.dart';
import 'package:taiko_songs/src/util/serialize.dart';

void main() {
  const base = 'https://wikiwiki.jp/taiko-fumen/%E4%BD%9C%E5%93%81';
  const url =
      'https://wikiwiki.jp/taiko-fumen/%E4%BD%9C%E5%93%81/NS2/%E5%A4%AA%E9%BC%93%E3%83%9F%E3%83%A5%E3%83%BC%E3%82%B8%E3%83%83%E3%82%AF%E3%83%91%E3%82%B9';
  const relative = 'NS2/太鼓ミュージックパス';
  test('resolve', () {
    expect(Uri.parse(base).resolve('a/s/d').toString(),
        'https://wikiwiki.jp/taiko-fumen/a/s/d');
    expect(Uri.parse('$base/').resolve('a/s/d').toString(),
        'https://wikiwiki.jp/taiko-fumen/%E4%BD%9C%E5%93%81/a/s/d');
  });
  test('BeanSerialize', () {
    expect(BeanSerialize.serialize(base, url), relative);
    expect(BeanSerialize.deserialize(base, relative), url);
  });
}
