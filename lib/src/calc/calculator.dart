import 'package:taiko_songs/src/bean/song.dart';

abstract class Calculator<T> {
  Stream<T> calc(Stream<T> source);

  Calculator<T> and(Calculator<T> other) {
    return AndCalculator(this, other);
  }
}

class AndCalculator<T> extends Calculator<T> {
  final Calculator<T> firstCalculator;
  final Calculator<T> nextCalculator;

  AndCalculator(this.firstCalculator, this.nextCalculator);

  @override
  Stream<T> calc(Stream<T> source) {
    return nextCalculator.calc(firstCalculator.calc(source));
  }
}

class SongCalculator extends Calculator<Song> {
  final CalcAction action;
  final Stream<Song> target;

  SongCalculator(this.action, this.target);

  @override
  Stream<Song> calc(Stream<Song> source) {
    switch (action) {
      case CalcAction.plus:
        return plus(source);
      case CalcAction.minus:
        return minus(source);
    }
  }

  Stream<Song> plus(Stream<Song> source) async* {
    Set<Song> exists = {};
    await for (Song song in source) {
      exists.add(song);
      yield song;
    }
    await for (Song song in target) {
      if (exists.add(song)) {
        yield song;
      }
    }
  }

  Stream<Song> minus(Stream<Song> source) async* {
    var toRemoveSet = await target.toSet();
    await for (Song song in source) {
      if (!toRemoveSet.contains(song)) {
        yield song;
      }
    }
  }
}

enum CalcAction { plus, minus }
