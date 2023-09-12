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
  late String assetsBase;
  late KeySerializer keySerializer;
  late DataSerializer dataSerializer;
  @override
  late Database db = getDefaultDatabase(base, keySerializer, dataSerializer);
  @override
  late Database assetsDB = getDefaultAssetsDatabase(assetsBase, dataSerializer);

  @override
  Future<void> init(
      {String? base,
      String? assetsBase,
      KeySerializer? keySerializer,
      DataSerializer? dataSerializer}) async {
    this.base = base ??= await getDefaultBase();
    this.assetsBase = assetsBase ??= 'assets/IronDB';
    this.keySerializer = keySerializer ?? const ReplaceFileSeparator();
    this.dataSerializer = dataSerializer ?? const JsonDataSerializer();
  }

  @override
  Database mix(List<Database> list) {
    return DatabaseMix(list);
  }
}
