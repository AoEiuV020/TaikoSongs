import '../database.dart';
import '../iron.dart';
import '../serialize.dart';
import 'database_impl.dart';
import 'database_mix.dart';
import 'serialize_impl.dart';
import 'utils_cmd.dart'
    if (dart.library.js_util) 'utils_web.dart'
    if (dart.library.ui) 'utils_flutter.dart';

class IronImpl implements IronInterface {
  // kIsWeb
  static const isWeb = bool.fromEnvironment('dart.library.js_util');
  static const isFlutter = bool.fromEnvironment('dart.library.ui');
  late String base;
  late String assetsBase;
  late KeySerializer keySerializer;
  late DataSerializer dataSerializer;

  @override
  Future<void> init(
      {String? base,
      String? assetsBase,
      KeySerializer? keySerializer,
      DataSerializer? dataSerializer}) async {
    this.base = base ??= await getDefaultBase();
    this.assetsBase = assetsBase ??= 'assets';
    this.keySerializer = keySerializer ?? const ReplaceFileSeparator();
    this.dataSerializer = dataSerializer ?? const JsonDataSerializer();
  }

  @override
  late Database db = _initDatabase();

  Database _initDatabase() {
    if (isWeb) {
      throw UnsupportedError('web not yet support!');
    }
    return DatabaseImpl(base, keySerializer, dataSerializer);
  }

  @override
  late Database assetsDB = _initAssetsDatabase();

  Database _initAssetsDatabase() {
    if (isWeb) {
      throw UnsupportedError('web not yet support!');
    }
    return DatabaseImpl(assetsBase, keySerializer, dataSerializer);
  }

  @override
  Database mix(List<Database> list) {
    return DatabaseMix(list);
  }
}
