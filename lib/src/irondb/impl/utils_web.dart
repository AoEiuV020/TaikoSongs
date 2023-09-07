import '../database.dart';
import '../serialize.dart';
import 'database_assets.dart';

Future<String> getDefaultBase() async => 'IronDB';

Database getDefaultAssetsDatabase(
        String assetsBase, DataSerializer dataSerializer) =>
    DatabaseAssets(assetsBase, '', dataSerializer);
