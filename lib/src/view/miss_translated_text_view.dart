import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:taiko_songs/src/view/translated_text_view.dart';

class MissTranslatedTextView extends StatelessWidget {
  const MissTranslatedTextView({super.key});

  static const routeName = '/miss_translated_text';

  @override
  Widget build(BuildContext context) {
    final text = TranslatedText.getMissTextSet().join('\n');
    return Scaffold(
      appBar: AppBar(
        title: const Text('未翻译文本'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: text));
                  EasyLoading.showToast(
                    "复制完成",
                    duration: const Duration(milliseconds: 500),
                  );
                },
                child: const Text('复制全部'),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  text,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
