import 'package:flutter_test/flutter_test.dart';
import 'package:taiko_songs/src/calc/calculator.dart';

void main() {
  group('Calculator', () {
    test('plus', () async {
      final Stream<int> s1 = Stream.fromIterable([1, 2, 3]);
      final Stream<int> s2 = Stream.fromIterable([2, 3, 4]);
      ICalculator<int> calc = Calculator(CalcAction.plus, const Stream.empty());
      calc = AndCalculator(calc, Calculator(CalcAction.plus, s1));
      calc = AndCalculator(calc, Calculator(CalcAction.plus, s2));
      expect({1, 2, 3, 4}, await calc.result().toSet());
    });
    test('plus3', () async {
      final Stream<int> s1 = Stream.fromIterable([1, 2, 3]);
      final Stream<int> s2 = Stream.fromIterable([2, 3, 4]);
      final Stream<int> s3 = Stream.fromIterable([3, 4, 5]);
      ICalculator<int> calc = Calculator(CalcAction.plus, const Stream.empty());
      calc = AndCalculator(calc, Calculator(CalcAction.plus, s1));
      calc = AndCalculator(calc, Calculator(CalcAction.plus, s2));
      calc = AndCalculator(calc, Calculator(CalcAction.plus, s3));
      expect({1, 2, 3, 4, 5}, await calc.result().toSet());
    });
    test('+-', () async {
      final Stream<int> s1 = Stream.fromIterable([1, 2, 3]);
      final Stream<int> s2 = Stream.fromIterable([2, 3, 4]);
      final Stream<int> s3 = Stream.fromIterable([3, 4, 5]);
      ICalculator<int> calc = Calculator(CalcAction.plus, const Stream.empty());
      calc = AndCalculator(calc, Calculator(CalcAction.plus, s1));
      calc = AndCalculator(calc, Calculator(CalcAction.minus, s2));
      calc = AndCalculator(calc, Calculator(CalcAction.plus, s3));
      expect({1, 3, 4, 5}, await calc.result().toSet());
    });
  });
}
