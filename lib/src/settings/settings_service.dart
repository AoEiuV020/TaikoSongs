import 'package:flutter/material.dart';
import 'package:shared_preferences_field_delegate/shared_preferences_field_delegate.dart';

class SettingsService {
  final Field<ThemeMode> themeMode;
  final Field<bool> translate;

  SettingsService(SharedPreferencesFieldFactory fieldFactory)
      : themeMode = Field.notNullable(
            source: fieldFactory.enumValue('themeMode', ThemeMode.values),
            defaultValue: ThemeMode.system),
        translate = Field.notNullable(
            source: fieldFactory.bool('translate'), defaultValue: true);
}
