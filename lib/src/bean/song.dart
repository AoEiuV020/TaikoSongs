class Song {
  final String name;

  Song(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
