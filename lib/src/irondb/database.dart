abstract interface class Database {
  Database sub(String table);

  Future<void> write(String key, dynamic value);

  Future<dynamic> read(String key);

  Future<void> drop();
}
