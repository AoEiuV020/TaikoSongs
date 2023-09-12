import '../database.dart';

class DatabaseStub implements Database {
  @override
  Database sub(String table) {
    return this;
  }

  @override
  Future<T?> read<T>(String key) async {
    return null;
  }

  @override
  Future<void> write<T>(String key, T? value) async {}

  @override
  Future<void> drop() async {}
}
