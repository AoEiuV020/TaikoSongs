import 'package:flutter/material.dart';
import 'package:shared_preferences_field_delegate/shared_preferences_field_delegate.dart';

import 'settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;
  late final translate = settingsField(_settingsService.translate);
  late final themeMode = settingsField(_settingsService.themeMode);
  late final visibleColumnList =
      settingsField(_settingsService.visibleColumnList);
  late final sortMap = settingsField(_settingsService.sortMap);

  SettingsField<T> settingsField<T>(Field<T> field) =>
      SettingsField(this, field);

  // 继承为public方法以便下方SettingsField调用,
  @override
  void notifyListeners() => super.notifyListeners();
}

class SettingsField<T> extends Field<T> {
  final SettingsController settings;
  final Field<T> field;

  SettingsField(this.settings, this.field);

  @override
  T get() => field.get();

  @override
  Stream<T> get onChanged => field.onChanged;

  @override
  Future<void> set(T value) async {
    await field.set(value);
    settings.notifyListeners();
  }

  Future<void> use(dynamic Function(T value) block) async {
    T value = get();
    await block(value);
    set(value);
  }
}
