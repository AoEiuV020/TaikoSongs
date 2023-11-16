import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../bean/release.dart';
import '../calc/calculator.dart';
import '../calc/song_calculator.dart';
import '../db/data.dart';
import 'song_list_view.dart';
import 'translated_text_view.dart';

class CalculatorView extends StatefulWidget {
  static const routeName = '/calculator';

  const CalculatorView({super.key});

  @override
  State<StatefulWidget> createState() => _CalculatorState();
}

class _CalculatorState extends State<StatefulWidget> {
  final logger = Logger('CalculatorView');
  final List<ReleaseItem> releaseList = [];
  final List<CalcAction> actionList = [];

  void onSelectReleaseClick() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final ScrollController scrollController = ScrollController();
          return AlertDialog(
            title: const Text('作品列表'),
            content: FutureBuilder(
                future: DataSource().getReleaseList().toList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Row(
                      children: [
                        CircularProgressIndicator(),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    logger.severe(
                        'initData failed', snapshot.error, snapshot.stackTrace);
                    return const Text('Error!');
                  }
                  var items = snapshot.requireData;
                  return SizedBox(
                    width: 400,
                    child: Scrollbar(
                      controller: scrollController,
                      interactive: true,
                      child: ListView.builder(
                        restorationId: 'releaseList',
                        controller: scrollController,
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = items[index];

                          return ListTile(
                              title: TranslatedText(item.name),
                              onTap: () {
                                Navigator.of(context).pop();
                                onReleaseSelected(item);
                              });
                        },
                      ),
                    ),
                  );
                }),
          );
        });
  }

  void onReleaseSelected(ReleaseItem releaseItem) {
    if (releaseList.length == actionList.length) {
      releaseList.add(releaseItem);
    } else {
      releaseList[releaseList.length - 1] = releaseItem;
    }
    setState(() {});
  }

  void onPlusClick() => onActionSelected(CalcAction.plus);

  void onMinusClick() => onActionSelected(CalcAction.minus);

  void onActionSelected(CalcAction action) {
    if (releaseList.length == actionList.length) {
      if (actionList.isEmpty) {
        return;
      }
      actionList[actionList.length - 1] = action;
    } else {
      actionList.add(action);
    }
    setState(() {});
  }

  void onBackspaceClick() {
    if (releaseList.length == actionList.length) {
      if (actionList.isEmpty) {
        return;
      }
      actionList.removeLast();
    } else {
      if (releaseList.isEmpty) {
        return;
      }
      releaseList.removeLast();
    }
    setState(() {});
  }

  void onCalculateClick() {
    logger.info('onCalculateClick');
    Navigator.pushNamed(
      context,
      SongListView.routeName,
      arguments: CalculatorArgument(releaseList, actionList),
    );
  }

  Widget buildCalculatingText() {
    final List<Widget> list = [];
    for (int i = 0; i < releaseList.length; i++) {
      final release = releaseList[i];
      list.add(TranslatedText(release.name));
      if (i < actionList.length) {
        final action = actionList[i];
        list.add(Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Text(action == CalcAction.plus ? '+' : '-'),
        ));
      }
    }
    return Wrap(
      children: list,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('计算歌曲列表并集差集'),
      ),
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(16),
            child: buildCalculatingText(),
          )),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onSelectReleaseClick,
                        child: const Text('选择作品'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: onBackspaceClick,
                      child: const Text('退格'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onPlusClick,
                              child: const Center(child: Text('加')),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onMinusClick,
                              child: const Center(child: Text('减')),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: onCalculateClick,
                      child: const Text('结果'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
