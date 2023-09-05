import '../serialize.dart';

class ReplaceFileSeparator implements KeySerializer {
  @override
  String serialize(String key) {
    RegExp specialChars = RegExp(r'[/\\:|=?";\[\],^]');
    return key.replaceAll(specialChars, '');
  }
}
