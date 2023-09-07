import 'database.dart';
import 'impl/iron_impl.dart';
import 'serialize.dart';

abstract interface class IronInterface {
  Future<void> init(
      {String? base,
      String? assetsBase,
      KeySerializer? keySerializer,
      DataSerializer? dataSerializer});

  Database get db;

  Database get assetsDB;

  Database mix(List<Database> list);
}

// ignore: non_constant_identifier_names
final IronInterface Iron = IronImpl();
