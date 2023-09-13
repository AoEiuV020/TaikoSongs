import 'package:flutter/material.dart';
import 'package:shared_preferences_field_delegate/shared_preferences_field_delegate.dart';

class SettingsService {
  final SharedPreferencesFieldFactory fieldFactory;
  final Field<ThemeMode> themeMode;

  SettingsService(this.fieldFactory)
      : themeMode = Field.notNullable(
            source: fieldFactory.enumValue('themeMode', ThemeMode.values),
            defaultValue: ThemeMode.system);
}
