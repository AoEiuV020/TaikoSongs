import '../database.dart';
import '../serialize.dart';
import 'database_assets.dart';
import 'database_stub.dart';

Future<String> getDefaultBase() async => 'IronDB';

Database getDefaultDatabase(String base, KeySerializer keySerializer,
        DataSerializer dataSerializer) =>
    DatabaseStub();

Database getDefaultAssetsDatabase(
        String assetsBase, DataSerializer dataSerializer) =>
    DatabaseAssets(assetsBase, '', dataSerializer);
