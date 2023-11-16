import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../bean/difficulty.dart';
import '../view/miss_translated_text_view.dart';
import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(builder: (context, settings, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              // Glue the SettingsController to the theme selection DropdownButton.
              //
              // When a user selects a theme from the dropdown list, the
              // SettingsController is updated, which rebuilds the MaterialApp.
              child: DropdownButton<ThemeMode>(
                // Read the selected themeMode from the controller
                value: settings.themeMode.get(),
                // Call the updateThemeMode method any time the user selects a theme.
                onChanged: (value) => settings.themeMode.set(value!),
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('System Theme'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Light Theme'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Dark Theme'),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Switch(
                    value: settings.translate.get(),
                    onChanged: (value) {
                      settings.translate.set(value);
                    },
                  ),
                  const Text('翻译（机翻+人工）'),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('展示内容'),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                children: List<Widget>.generate(7, (int index) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: settings.visibleColumnList.get()[index],
                        onChanged: (value) {
                          final list = settings.visibleColumnList.get();
                          list[index] = value!;
                          settings.visibleColumnList.set(list);
                        },
                      ),
                      index == 0
                          ? const Text('副标题')
                          : index == 1
                              ? const Text('BPM')
                              : Text(DifficultyItem.difficultyTypeStringMap[
                                  DifficultyType.values[index - 2]]!),
                    ],
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  await settings.sortMap.use((value) => value.clear());
                  EasyLoading.showToast(
                    "重置完成",
                    duration: const Duration(milliseconds: 500),
                  );
                },
                child: const Text('重置排序'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.restorablePushNamed(
                    context,
                    MissTranslatedTextView.routeName,
                  );
                },
                child: const Text('查看未翻译文本'),
              ),
            ),
          ],
        ),
      );
    });
  }
}
