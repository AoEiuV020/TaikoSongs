abstract interface class KeySerializer {
  String serialize(String key);
}

abstract interface class SubSerializer {
  String serialize(String key);
}

abstract interface class DataSerializer {
  String serialize<T>(T value);

  T deserialize<T>(String str);
}
