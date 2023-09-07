abstract interface class Database {
  Database sub(String table);

  Future<void> write<T>(String key, T? value);

  Future<T?> read<T>(String key);

  Future<void> drop();
}
