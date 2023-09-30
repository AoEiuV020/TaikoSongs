import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:taiko_songs/src/async/isolate_transformer.dart';

import '../settings/settings_controller.dart';

class TranslatedText extends StatefulWidget {
  final String originalText;
  final TextStyle? style;

  const TranslatedText(this.originalText, {super.key, this.style});

  @override
  _TranslatedTextState createState() => _TranslatedTextState();

  static Set<String> getMissTextSet() => _TranslatedTextState.missSet;
}

class _TranslatedTextState extends State<TranslatedText> {
  final logger = Logger('TranslatedText');
  static Future<Map<String, String>> translatedMap = _initTranslatedMap();
  static final Set<String> missSet = {};
  static final jpRegex = RegExp(r'[ぁ-んァ-ン]');
  String translatedText = '';

  static Future<Map<String, String>> _initTranslatedMap() async {
    final transformer = IsolateTransformer();
    final Map<String, String> resultMap = {};
    await _loadAssets(transformer, resultMap, 'release_name.txt');
    await _loadAssets(transformer, resultMap, 'song_name_ps4.txt');
    await _loadAssets(transformer, resultMap, 'song_name_slash.txt');
    await _loadAssets(transformer, resultMap, 'song_name_ns2.txt');
    await _loadAssets(transformer, resultMap, 'other.txt');
    return resultMap;
  }

  static Future<void> _loadAssets(IsolateTransformer transformer,
      Map<String, String> resultMap, String filename) async {
    final bundle = await rootBundle.load('assets/translate/$filename');
    final stream = transformer.transform(
        Stream.value(bundle),
            (e) => e
            .asyncMap((data) => utf8.decode(data.buffer.asUint8List()))
            .transform(const LineSplitter())
            .where((event) => event.isNotEmpty)
            .where((event) => !event.startsWith('//'))
            .map((event) => event.split(' ==> '))
            .where((event) => event.length > 1)
            .map((event) => MapEntry(event[0], event[1])));
    await for (final entry in stream) {
      resultMap[entry.key] = entry.value;
    }
  }

  @override
  void initState() {
    super.initState();
    translatedText = widget.originalText;
    translateText(widget.originalText);
  }

  void translateText(String textToTranslate) async {
    final map = await translatedMap;
    final result = map[textToTranslate];
    if (result != null) {
      setState(() {
        translatedText = result;
      });
    } else if (missSet.contains(textToTranslate)) {
      // 这里是已知不存在的，
    } else if (jpRegex.hasMatch(textToTranslate)) {
      logger.info('miss: $textToTranslate');
      missSet.add(textToTranslate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(builder: (context, settings, child) {
      if (settings.translate.get()) {
        return Text(translatedText, style: widget.style);
      }
      return Text(widget.originalText, style: widget.style);
    });
  }
}
