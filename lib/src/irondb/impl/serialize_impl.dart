import 'dart:convert';

import '../serialize.dart';

class ReplaceFileSeparator implements KeySerializer {
  const ReplaceFileSeparator();

  @override
  String serialize(String key) {
    RegExp specialChars = RegExp(r'[/\\:|=?";\[\],^]');
    return key.replaceAll(specialChars, '');
  }
}

class JsonDataSerializer implements DataSerializer {
  const JsonDataSerializer();

  @override
  T deserialize<T>(String str) {
    if (T == String) {
      return str as T;
    }
    return jsonDecode(str) as T;
  }

  @override
  String serialize<T>(T value) {
    if (T == String) {
      return value as String;
    }
    return jsonEncode(value);
  }
}
