// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_field_delegate/shared_preferences_field_delegate.dart';
import 'package:taiko_songs/src/irondb/iron.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  // 确保 Flutter 初始化完成
  WidgetsFlutterBinding.ensureInitialized();
  await Iron.init();
  final sharedPreferences = await SharedPreferences.getInstance();
  final fieldFactory = SharedPreferencesFieldFactory(sharedPreferences);
  final settingsController = SettingsController(SettingsService(fieldFactory));

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(
    ChangeNotifierProvider(
      create: (context) => settingsController,
      child: const MyApp(),
    ),
  );
}
