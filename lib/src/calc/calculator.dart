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

class SongCalculator extends Calculator<SongItem> {
  final CalcAction action;
  final Stream<SongItem> target;

  SongCalculator(this.action, this.target);

  @override
  Stream<SongItem> calc(Stream<SongItem> source) {
    switch (action) {
      case CalcAction.plus:
        return plus(source);
      case CalcAction.minus:
        return minus(source);
    }
  }

  Stream<SongItem> plus(Stream<SongItem> source) async* {
    Set<SongItem> exists = {};
    await for (SongItem song in source) {
      exists.add(song);
      yield song;
    }
    await for (SongItem song in target) {
      if (exists.add(song)) {
        yield song;
      }
    }
  }

  Stream<SongItem> minus(Stream<SongItem> source) async* {
    var toRemoveSet = await target.toSet();
    await for (SongItem song in source) {
      if (!toRemoveSet.contains(song)) {
        yield song;
      }
    }
  }
}

enum CalcAction { plus, minus }
