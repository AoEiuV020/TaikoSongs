// ignore_for_file: inference_failure_on_function_invocation

import 'package:flutter_test/flutter_test.dart';

T? read<T>() {
  if (T == String) {
    return 'String' as T;
  }
  return null;
}

void main() {
  test('type', () async {
    var a = read();
    expect(a, null);
    try {
      // ignore: invalid_assignment, unused_local_variable
      String b = read();
      throw StateError('unreachable');
    } catch (e) {
      expect(e.toString(), "type 'Null' is not a subtype of type 'String'");
    }
    String? c = read();
    expect(c, 'String');
    String? d = '';
    // ignore: invalid_assignment
    d = read();
    expect(d, null);
    d = read();
    expect(d, 'String');
    d = read();
    expect(d, 'String');
    String? e = '';
    e = read<String>();
    expect(e, 'String');
    String? f;
    f = read();
    expect(f, 'String');
  });
}
