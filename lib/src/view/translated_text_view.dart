import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../db/data.dart';
import '../settings/settings_controller.dart';

class TranslatedText extends StatefulWidget {
  final String originalText;
  final TextStyle? style;
  final TextOverflow? overflow;

  const TranslatedText(this.originalText,
      {super.key, this.style, this.overflow});

  @override
  _TranslatedTextState createState() => _TranslatedTextState();

  static Set<String> getMissTextSet() => _TranslatedTextState.missSet;
}

class _TranslatedTextState extends State<TranslatedText> {
  final logger = Logger('TranslatedText');
  static final Set<String> missSet = {};
  static final jpRegex = RegExp(r'[ぁ-んァ-ン]');
  String translatedText = '';
  static final ds = DataSource();

  @override
  void initState() {
    super.initState();
    translatedText = widget.originalText;
    translateText(widget.originalText);
  }

  void translateText(String textToTranslate) async {
    final result = await ds.getTranslated(textToTranslate);
    if (mounted && result != null) {
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
        return Text(
          translatedText,
          style: widget.style,
          overflow: widget.overflow,
        );
      }
      return Text(
        widget.originalText,
        style: widget.style,
        overflow: widget.overflow,
      );
    });
  }
}
