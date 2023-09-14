import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences_field_delegate/shared_preferences_field_delegate.dart';

class SettingsService {
  final Field<ThemeMode> themeMode;
  final Field<bool> translate;

  /// 0: subtitle, 1: BPM, 2-6: difficulty,
  final Field<List<bool>> visibleColumnList;

  /// key: 0:category, 1:name, 2:bpm, 3-7:difficultyTypeStringMap,
  /// value: true:asc, false:desc,
  final Field<Map<String, bool>> sortMap;

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
            defaultValue: List<bool>.filled(7, true)),
        sortMap = Field.notNullable(
            source: Field.map(
                source: fieldFactory.string('sortMap'),
                mapToSource: json.encode,
                mapFromSource: (value) => value == null
                    ? null
                    : Map<String, bool>.from(json.decode(value) as Map)),
            defaultValue: {});
}
