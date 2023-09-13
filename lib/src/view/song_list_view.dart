import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:taiko_songs/src/bean/difficulty.dart';
import 'package:taiko_songs/src/bean/release.dart';
import 'package:taiko_songs/src/bean/song.dart';
import 'package:taiko_songs/src/db/data.dart';

import '../settings/settings_controller.dart';
import '../settings/settings_view.dart';
import 'difficulty_detail_view.dart';
import 'translated_text_view.dart';

class SongListView extends StatelessWidget {
  SongListView({super.key, required this.releaseItem});

  static const routeName = '/song_list';

  final ReleaseItem releaseItem;
  final logger = Logger('SongListView');
  final ScrollController _scrollController = ScrollController();

  Future<List<SongItem>> initData(List<bool> visibleList) {
    return DataSource()
        .getSongList(releaseItem)
        .where((song) {
          for (var i = 0; i < 5; ++i) {
            final visibleIndex = i + 2;
            final visible = visibleList[visibleIndex];
            if (!visible) {
              continue;
            }
            final level = song.getLevelTypeDifficulty(DifficultyType.values[i]);
            if (level > 0) {
              return true;
            }
          }
          return false;
        })
        .toList()
        .then((value) => value
          ..sort(
            (a, b) =>
                a.getLevelTypeDifficulty(DifficultyType.oni) -
                b.getLevelTypeDifficulty(DifficultyType.oni),
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            TranslatedText(releaseItem.name),
            const Text('-歌曲列表'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Consumer<SettingsController>(builder: (context, settings, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('曲名'),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: settings.visibleColumnList.get()[1],
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('BPM'),
                    ),
                  ),
                  Row(
                    children: DifficultyType.values.indexed
                        .where((event) {
                          final (int i, _) = event;
                          return settings.visibleColumnList.get()[i + 2];
                        })
                        .map((e) => e.$2)
                        .map((e) => InkWell(
                              onTap: () {
                                logger.fine('order click');
                              },
                              child: SizedBox(
                                width: 32,
                                height: 32,
                                child: Container(
                                  color: Color(0x88000000 |
                                      DifficultyItem
                                          .difficultyTypeColorMap[e]!),
                                  child: Center(
                                    child: Text(
                                      DifficultyItem.difficultyTypeStringMap[e]!
                                          .substring(0, 1),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            FutureBuilder(
                future: initData(settings.visibleColumnList.get()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    logger.severe(
                        'initData failed', snapshot.error, snapshot.stackTrace);
                    return const Text('Error!');
                  }
                  var items = snapshot.requireData;
                  return Expanded(
                    child: Scrollbar(
                      controller: _scrollController,
                      interactive: true,
                      child: ListView.builder(
                        restorationId: 'songList',
                        controller: _scrollController,
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = items[index];

                          final Widget difficultyGroup = Row(
                            children: DifficultyType.values.indexed
                                .where((event) {
                                  final (int i, _) = event;
                                  return settings.visibleColumnList
                                      .get()[i + 2];
                                })
                                .map((e) => e.$2)
                                .map((e) => InkWell(
                                      onTap: item.difficultyMap.containsKey(e)
                                          ? () {
                                              Navigator.restorablePushNamed(
                                                context,
                                                DifficultyDetailView.routeName,
                                                arguments: item
                                                    .difficultyMap[e]!
                                                    .toJson(),
                                              );
                                            }
                                          : null,
                                      child: SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: Container(
                                          color: Color(0x88000000 |
                                              DifficultyItem
                                                  .difficultyTypeColorMap[e]!),
                                          child: Center(
                                            child: Text(
                                              item
                                                  .getLevelTypeDifficulty(e)
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          );
                          return InkWell(
                            child: Container(
                              color: item.categoryColor == null
                                  ? null
                                  : Color(0x22000000 | item.categoryColor!),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item.name),
                                        Visibility(
                                          visible: item.subtitle.isNotEmpty &&
                                              settings.visibleColumnList
                                                  .get()[0],
                                          child: Text(
                                            item.subtitle,
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        settings.visibleColumnList.get()[1],
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(item.bpm),
                                    ),
                                  ),
                                  difficultyGroup,
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
          ],
        );
      }),
    );
  }
}
