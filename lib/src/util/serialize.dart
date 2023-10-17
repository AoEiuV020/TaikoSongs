import 'package:path/path.dart' as path;

/// 针对本项目的序列化处理，不通用，
class BeanSerialize {
  BeanSerialize._();

  static String deserialize(String base, String str) {
    final relative = Uri.encodeFull(str);
    if (!base.endsWith('/')) {
      base = '$base/';
    }
    return Uri.parse(base).resolve(relative).toString();
  }

  static String serialize(String base, String url) {
    final relative = path.relative(url, from: base);
    return Uri.decodeFull(relative);
  }
}
