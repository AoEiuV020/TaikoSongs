import 'package:flutter/foundation.dart';

import '../database.dart';
import '../iron.dart';
import 'database_impl.dart';

class IronImpl implements IronInterface {
  String? base;

  @override
  void init({String? base}) {
    this.base = base;
  }

  @override
  late Database db = _initDatabase();

  Database _initDatabase() {
    if (kIsWeb) {
      throw UnsupportedError('web not yet support!');
    }
    return DatabaseImpl(base);
  }
}
