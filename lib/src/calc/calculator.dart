

abstract class ICalculator<T> {
  Stream<T> calc(Stream<T> source);

  Stream<T> result() {
    return calc(Stream<T>.empty());
  }

  ICalculator<T> and(ICalculator<T> other) {
    return AndCalculator(this, other);
  }
}

class AndCalculator<T> extends ICalculator<T> {
  final ICalculator<T> firstCalculator;
  final ICalculator<T> nextCalculator;

  AndCalculator(this.firstCalculator, this.nextCalculator);

  @override
  Stream<T> calc(Stream<T> source) {
    return nextCalculator.calc(firstCalculator.calc(source));
  }
}

class Calculator<T> extends ICalculator<T> {
  final CalcAction action;
  final Stream<T> target;

  Calculator(this.action, this.target);

  @override
  Stream<T> calc(Stream<T> source) {
    switch (action) {
      case CalcAction.plus:
        return plus(source);
      case CalcAction.minus:
        return minus(source);
    }
  }

  Stream<T> plus(Stream<T> source) async* {
    Set<T> exists = {};
    await for (T song in source) {
      exists.add(song);
      yield song;
    }
    await for (T song in target) {
      if (exists.add(song)) {
        yield song;
      }
    }
  }

  Stream<T> minus(Stream<T> source) async* {
    var toRemoveSet = await target.toSet();
    await for (T song in source) {
      if (!toRemoveSet.contains(song)) {
        yield song;
      }
    }
  }
}

enum CalcAction { plus, minus }
