import 'package:hive_flutter/hive_flutter.dart';

import 'hive_keys.dart';

class HiveStorage {
  HiveStorage._();

  static final HiveStorage instance = HiveStorage._();

  Future<void> init() async {
    await Hive.initFlutter();

    await Hive.openBox<String>(
      HiveKeys.bookmarksBox,
    );
  }

  Box<String> get bookmarksBox {
    return Hive.box<String>(
      HiveKeys.bookmarksBox,
    );
  }
}