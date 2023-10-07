import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../serialize.dart';

class ReplaceFileSeparator implements KeySerializer {
  const ReplaceFileSeparator();

  @override
  String serialize(String key) {
    RegExp specialChars = RegExp(r'[/\\:|=?";\[\],^]');
    return key.replaceAll(specialChars, '');
  }
}

/// assets不支持汉字等，会自动url编码，导致长度变三倍，
/// 这里判断太长就使用md5摘要转16进制编码得到32字符，
class AssetsFilenameSerializer implements KeySerializer {
  const AssetsFilenameSerializer();

  @override
  String serialize(String key) {
    final encoded = Uri.encodeComponent(key);
    if (encoded.length > 32) {
      final bytes = utf8.encode(key);
      key = md5.convert(bytes).toString();
    } else {
      key = encoded;
    }
    return key;
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
