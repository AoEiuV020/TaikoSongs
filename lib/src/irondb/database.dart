abstract class Database {
  Database sub(String table);

  Future<void> write(String key, dynamic value);

  Future<void> writeString(String key, String? value) async {
    return write(key, value);
  }

  Future<dynamic> read(String key);

  Future<String?> readString(String key) async {
    return (await read(key)) as String?;
  }

  Future<void> drop();
}
