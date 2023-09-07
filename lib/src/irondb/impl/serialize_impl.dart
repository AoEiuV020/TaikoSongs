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
/// 所以这里判断字节数≥15就使用md5摘要转16进制编码得到32字符，
class AssetsFilenameSerializer implements KeySerializer {
  const AssetsFilenameSerializer();

  @override
  String serialize(String key) {
    final bytes = utf8.encode(key);
    if (bytes.length >= 15) {
      key = md5.convert(bytes).toString();
    } else {
      key = Uri.encodeComponent(key);
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
