import 'database.dart';
import 'impl/iron_impl.dart';
import 'serialize.dart';

abstract interface class IronInterface {
  void init(
      {String? base,
      KeySerializer? keySerializer,
      DataSerializer? dataSerializer});

  Database get db;
}

// ignore: non_constant_identifier_names
final IronInterface Iron = IronImpl();
