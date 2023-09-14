import 'dart:core';

Comparator<T> thenComparing<T, U extends Comparable<dynamic>>(
    Comparator<T> current, KeyExtractor<T, U> keyExtractor) {
  return thenComparing0(current, comparing(keyExtractor));
}

Comparator<T> thenComparing0<T>(Comparator<T> current, Comparator<T> other) {
  return (c1, c2) {
    int res = current(c1, c2);
    return (res != 0) ? res : other(c1, c2);
  };
}

Comparator<T> comparing<T, U extends Comparable<dynamic>>(
    KeyExtractor<T, U> keyExtractor) {
  return (c1, c2) => keyExtractor(c1).compareTo(keyExtractor(c2));
}

typedef KeyExtractor<T, U extends Comparable<dynamic>> = U Function(T t);

Comparator<T> reversed<T>(Comparator<T> current) {
  return (c1, c2) {
    return current(c2, c1);
  };
}
