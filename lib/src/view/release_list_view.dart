import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../db/data.dart';
import '../settings/settings_view.dart';
import 'calculator_view.dart';
import 'search_release_list_view.dart';
import 'song_list_view.dart';
import 'translated_text_view.dart';

class ReleaseListView extends StatelessWidget {
  ReleaseListView({
    super.key,
  });

  static const routeName = '/release_list';
  final logger = Logger('ReleaseListView');
  final ScrollController _scrollController = ScrollController();

  void search(BuildContext context, String text) {
    if (text.isEmpty) {
      return;
    }
    Navigator.restorablePushNamed(
      context,
      SearchReleaseListView.routeName,
      arguments: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('作品列表'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  final TextEditingController textEditingController =
                      TextEditingController();
                  return AlertDialog(
                    title: const Text('清输入搜索关键字'),
                    content: TextField(
                      controller: textEditingController,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (text) {
                        Navigator.of(context).pop();
                        search(context, text);
                      },
                      decoration: const InputDecoration(labelText: '空格分隔多个关键字'),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('取消'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('确定'),
                        onPressed: () {
                          Navigator.of(context).pop(); // 关闭对话框
                          String text = textEditingController.text;
                          search(context, text);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: () {
              Navigator.restorablePushNamed(context, CalculatorView.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: FutureBuilder(
            future: DataSource().getReleaseList().toList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                logger.severe(
                    'initData failed', snapshot.error, snapshot.stackTrace);
                return const Text('Error!');
              }
              var items = snapshot.requireData;
              return Scrollbar(
                controller: _scrollController,
                interactive: true,
                child: ListView.builder(
                  restorationId: 'releaseList',
                  controller: _scrollController,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = items[index];

                    return ListTile(
                        title: TranslatedText(item.name),
                        onTap: () {
                          Navigator.restorablePushNamed(
                            context,
                            SongListView.routeName,
                            arguments: item.toJson(),
                          );
                        });
                  },
                ),
              );
            }),
      ),
    );
  }
}
