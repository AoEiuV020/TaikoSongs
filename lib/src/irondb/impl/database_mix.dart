import '../database.dart';

class DatabaseMix implements Database {
  final List<Database> list;

  DatabaseMix(this.list);

  @override
  Database sub(String table) {
    return DatabaseMix(list.map((e) => e.sub(table)).toList());
  }

  @override
  Future<void> write<T>(String key, T? value) async {
    await Future.wait(list.map((e) => e.write<T>(key, value)));
  }

  @override
  Future<T?> read<T>(String key) async {
    for (var db in list) {
      final result = await db.read<T>(key);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  @override
  Future<void> drop() async {
    await Future.wait(list.map((e) => e.drop()));
  }
}
