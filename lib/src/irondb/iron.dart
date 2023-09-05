import 'package:taiko_songs/src/irondb/database.dart';
import 'package:taiko_songs/src/irondb/impl/iron_impl.dart';

abstract interface class IronInterface {
  void init({String? base});

  Database get db;
}

// ignore: non_constant_identifier_names
final IronInterface Iron = IronImpl();
