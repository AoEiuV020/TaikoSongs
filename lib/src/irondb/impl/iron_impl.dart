
import '../database.dart';
import '../iron.dart';
import '../serialize.dart';
import 'database_impl.dart';

class IronImpl implements IronInterface {
  String? base;
  KeySerializer? keySerializer;

  @override
  void init({String? base, KeySerializer? keySerializer}) {
    this.base = base;
  }

  @override
  late Database db = _initDatabase();

  Database _initDatabase() {
    // kIsWeb
    if (const bool.fromEnvironment('dart.library.js_util')) {
      throw UnsupportedError('web not yet support!');
    }
    return DatabaseImpl(base, keySerializer);
  }
}
