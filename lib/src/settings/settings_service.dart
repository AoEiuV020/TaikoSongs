import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences_field_delegate/shared_preferences_field_delegate.dart';

class SettingsService {
  final Field<ThemeMode> themeMode;
  final Field<bool> translate;
  final Field<List<bool>> visibleColumnList;

  SettingsService(SharedPreferencesFieldFactory fieldFactory)
      : themeMode = Field.notNullable(
            source: fieldFactory.enumValue('themeMode', ThemeMode.values),
            defaultValue: ThemeMode.system),
        translate = Field.notNullable(
            source: fieldFactory.bool('translate'), defaultValue: true),
        visibleColumnList = Field.notNullable(
            source: Field.map(
                source: fieldFactory.string('visibleColumnList'),
                mapToSource: json.encode,
                mapFromSource: (value) => value == null
                    ? null
                    : List<bool>.from(json.decode(value) as List)),
            defaultValue: List<bool>.filled(7, true));
}
