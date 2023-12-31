import '../database.dart';
import '../iron.dart';
import '../serialize.dart';
import 'database_mix.dart';
import 'serialize_impl.dart';
import 'utils_cmd.dart'
    if (dart.library.js_util) 'utils_web.dart'
    if (dart.library.ui) 'utils_flutter.dart';

class IronImpl implements IronInterface {
  late String base;
  late KeySerializer keySerializer;
  late DataSerializer dataSerializer;
  @override
  late Database db = getDefaultDatabase(base, keySerializer, dataSerializer);

  @override
  Future<void> init({String? base,
    KeySerializer? keySerializer,
    DataSerializer? dataSerializer}) async {
    this.base = base ??= await getDefaultBase();
    this.keySerializer = keySerializer ?? const ReplaceFileSeparator();
    this.dataSerializer = dataSerializer ?? const JsonDataSerializer();
  }


  @override
  Database assetsDB([String assetsBase = 'assets/IronDB']) {
    return getDefaultAssetsDatabase(assetsBase, dataSerializer);
  }

  @override
  Database mix(List<Database> list) {
    return DatabaseMix(list);
  }
}
