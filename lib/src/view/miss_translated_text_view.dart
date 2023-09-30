import 'package:flutter/material.dart';
import 'package:taiko_songs/src/view/translated_text_view.dart';

class MissTranslatedTextView extends StatelessWidget {
  const MissTranslatedTextView({super.key});

  static const routeName = '/miss_translated_text';

  String makeText() {
    return TranslatedText.getMissTextSet().join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('未翻译文本'),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: SelectableText(
            makeText(),
          ),
        ),
      ),
    );
  }
}
