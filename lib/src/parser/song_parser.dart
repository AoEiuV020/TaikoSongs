import 'dart:math';

import 'package:html/parser.dart';

import '../bean/difficulty.dart';
import '../bean/song.dart';
import 'base.dart';
import 'table.dart';

class SongParser extends Parser {
  Stream<SongItem> parseList(String baseUrl, String doc) async* {
    var root = parse(doc);
    var divList = root.querySelectorAll('#content > div');
    for (var div in divList) {
      if (div.className.trim() == 'navfold-container clearfix') {
        continue;
      }
      var tableList =
          div.querySelectorAll('table').map((e) => parseTable(e)).toList();
      for (var table in tableList) {
        var headCellList = table.head?.content;
        if (headCellList == null) {
          continue;
        }
        var bpmIndex = -1;
        for (var i = 0; i < headCellList.length; i++) {
          if (i - 1 < 0 || i + 2 >= headCellList.length) {
            // BPM前面是曲名， 后面是至少四个难度,
            // 不过AC1没有魔王，
            // Beena只有两个难度，
            continue;
          }
          var cell = headCellList[i];
          if (cell.text.startsWith("BPM")) {
            bpmIndex = i;
            break;
          }
        }
        if (bpmIndex == -1) {
          continue;
        }
        int? categoryIndex;
        for (var i = 0; i < bpmIndex; ++i) {
          if (headCellList[i].text == 'ジャンル') {
            categoryIndex = i;
            break;
          }
        }
        SongItem? previous;
        for (var data in table.data) {
          final title = data.title;
          final TableCell? categoryCell;
          if (title != null) {
            categoryCell = title;
          } else if (categoryIndex != null) {
            categoryCell = data.row.content[categoryIndex];
          } else {
            categoryCell = null;
          }
          final String category;
          final int? categoryColor;
          if (categoryCell != null) {
            category = categoryCell.text;
            categoryColor = getBackgroundColor(categoryCell.ele);
          } else {
            category = '';
            categoryColor = null;
          }
          final String name;
          final String subtitle;
          if (bpmIndex >= 2 &&
              headCellList[bpmIndex - 1] == headCellList[bpmIndex - 2]) {
            var nameTd = data.getByIndex(bpmIndex - 2).ele;
            name = nameTd.text.trim();
            var subtitleSpan = data.getByIndex(bpmIndex - 1).ele;
            subtitle = subtitleSpan.text.trim();
          } else {
            var nameTd = data.getByIndex(bpmIndex - 1).ele;
            if (nameTd.children.length > 1) {
              name = nameTd.children[0].text.trim();
            } else {
              name = nameTd.text.trim();
            }
            var subtitleSpan = nameTd.querySelector('span');
            subtitle = subtitleSpan?.text.trim() ?? "";
          }
          var bpm = data.getByIndex(bpmIndex).text;
          Map<DifficultyType, DifficultyItem> difficultyMap = {};
          for (var (i, cell) in data.row.content
              .sublist(bpmIndex + 1, min(bpmIndex + 6, data.row.content.length))
              .indexed) {
            var type = DifficultyType.values[i];
            var td = cell.ele;
            var a = td.querySelector('a');
            if (a == null) {
              continue;
            }
            var text = a.text;
            if (!text.startsWith('★×')) {
              continue;
            }
            var levelText = text.substring(2);
            var level = int.parse(levelText);
            var span = td.querySelector('span');
            var hasBranch = span != null && span.text == "譜面分岐";
            var url = getAbsHref(baseUrl, a);
            var difficulty = DifficultyItem(name, type, level, hasBranch, url);
            difficultyMap[type] = difficulty;
          }
          var song = SongItem(
              name, subtitle, category, categoryColor, bpm, difficultyMap);
          if (previous != null) {
            if (name == previous.name ||
                (name.startsWith(previous.name) && name.endsWith('(裏)'))) {
              previous.difficultyMap[DifficultyType.uraOni] =
                  DifficultyItem.uraOni(difficultyMap[DifficultyType.oni]!);
              continue;
            }
          }
          previous = song;
          yield song;
        }
      }
    }
  }
}
