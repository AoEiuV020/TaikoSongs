import 'dart:core';

Comparator<T> comparing<T, U extends Comparable<dynamic>>(
    KeyExtractor<T, U> keyExtractor) {
  return (c1, c2) => keyExtractor(c1).compareTo(keyExtractor(c2));
}

typedef KeyExtractor<T, U extends Comparable<dynamic>> = U Function(T t);

Comparator<T> basicComparing<T>(List<T> list) {
  Map<T, int> indexMap = {};
  for (int i = 0; i < list.length; i++) {
    final item = list[i];
    indexMap[item] = i;
  }
  return (c1, c2) => indexMap[c1]!.compareTo(indexMap[c2]!);
}
