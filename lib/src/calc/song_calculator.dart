import '../bean/release.dart';
import '../bean/song.dart';
import '../db/data.dart';
import 'calculator.dart';

class CalculatorArgument {
  final List<ReleaseItem> releaseList;
  final List<CalcAction> actionList;

  CalculatorArgument(this.releaseList, this.actionList);

  Stream<SongItem> getStream() {
    final ds = DataSource();
    ICalculator<SongItem> calc =
        Calculator(CalcAction.plus, const Stream.empty());
    for (int i = 0; i < releaseList.length; i++) {
      final release = releaseList[i];
      final CalcAction action;
      if (i == 0) {
        action = CalcAction.plus;
      } else {
        action = actionList[i - 1];
      }
      final songStream = ds.getSongList(release);
      calc = AndCalculator(calc, Calculator(action, songStream));
    }
    return calc.result();
  }
}
