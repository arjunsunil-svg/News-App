import 'package:flutter/material.dart';
import 'app.dart';
import 'core/storage/hive_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveStorage.instance.init();

  runApp(const App());
}
