abstract interface class KeySerializer {
  String serialize(String key);
}

typedef SubSerializer = KeySerializer;

abstract interface class DataSerializer {
  String serialize<T>(T value);

  T deserialize<T>(String str);
}
