import '../database.dart';
import '../serialize.dart';
import 'database_assets.dart';

Future<String> getDefaultBase() async => 'IronDB';

Database getDefaultAssetsDatabase(String assetsBase,
        KeySerializer keySerializer, DataSerializer dataSerializer) =>
    DatabaseAssets(assetsBase, '', keySerializer, dataSerializer);
