import 'package:collection/collection.dart';
import 'package:html/dom.dart';

class Table {
  final List<TableRow> content;
  late TableRow? head = content.firstWhereOrNull((row) => !row.fullRow);
  late List<TableData> data = _dataInit();

  Table(this.content);

  static Table fromElement(Element table) {
    if (table.localName != 'table') {
      throw StateError('The element is not a <table> tag.');
    }
    final List<TableRow> content = [];
    var trList = table.getElementsByTagName('tr');
    final List<TableRowSpanCache> rowCacheList = [];
    for (var tr in trList) {
      var tdList = tr.children;
      final List<TableCell> cellList = [];
      var i = 0;
      do {
        do {
          var cellIndex = cellList.length;
          var cache = rowCacheList
              .firstWhereOrNull((element) => element.cellIndex == cellIndex);
          if (cache == null) {
            break;
          }
          for (int j = 0; j < cache.cell.colSpan; j++) {
            cellList.add(cache.cell);
          }
          cache.rowSpanLeft -= 1;
          if (cache.rowSpanLeft == 0) {
            rowCacheList.remove(cache);
          }
        } while (true);
        if (tdList.isEmpty) {
          break;
        }
        final td = tdList[i]; // maybe th,
        var colspan = int.parse(td.attributes['colspan'] ?? '1');
        var rowspan = int.parse(td.attributes['rowspan'] ?? '1');
        var cell = TableCell(td, colSpan: colspan, rowSpan: rowspan);
        if (rowspan > 1) {
          rowCacheList
              .add(TableRowSpanCache(cellList.length, cell, rowspan - 1));
        }
        for (int k = 0; k < colspan; k++) {
          cellList.add(cell);
        }
        ++i;
      } while (i < tdList.length);
      content.add(TableRow(cellList));
    }

    return Table(content);
  }

  List<TableData> _dataInit() {
    final List<TableData> list = [];
    TableRow? head = this.head;
    if (head == null) {
      return list;
    }
    late TableCell title;
    for (int i = 0; i < content.length; i++) {
      var row = content[i];
      if (row.fullRow) {
        title = row.content[0];
        continue;
      }
      if (row == head) {
        continue;
      }
      list.add(TableData(title, row, head.indexMap));
    }
    return list;
  }
}

class TableRowSpanCache {
  int cellIndex;
  TableCell cell;
  int rowSpanLeft;

  TableRowSpanCache(this.cellIndex, this.cell, this.rowSpanLeft);
}

class TableData {
  final TableCell title;
  final TableRow row;
  final Map<String, int> indexMap;

  TableData(this.title, this.row, this.indexMap);

  TableCell getByName(String key) {
    return row.content[indexMap[key]!];
  }

  TableCell getByIndex(int index) {
    return row.content[index];
  }
}

class TableRow {
  final List<TableCell> content;
  late Map<String, int> indexMap = _initIndexMap();

  TableRow(this.content);

  bool get fullRow {
    return content[0].colSpan == content.length;
  }

  Map<String, int> _initIndexMap() {
    final Map<String, int> map = {};
    for (int i = 0; i < content.length; i++) {
      var headTd = content[i];
      // 表头可能包含换行和空格，这里这里都是不需要的,
      var name = headTd.text.replaceAll(' ', '');
      map.putIfAbsent(name, () => i);
    }
    return map;
  }
}

class TableCell {
  final int colSpan;
  final int rowSpan;
  final Element ele; // td or th,
  late String text = ele.text.trim().replaceAll(' ', ' ');

  TableCell(this.ele, {this.colSpan = 1, this.rowSpan = 1});
}
