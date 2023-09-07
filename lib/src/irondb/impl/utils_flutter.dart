import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

// linux: /home/username/.local/share/com.aoeiuv020.taiko_songs
Future<String> getDefaultBase() async {
  final folder = await getApplicationSupportDirectory();
  return path.join(folder.path, 'IronDB');
}
