import 'dart:io';

import 'package:path/path.dart' as path;

// linux: /tmp
Future<String> getDefaultBase() async {
  final folder = Directory.systemTemp;
  return path.join(folder.path, 'IronDB');
}
