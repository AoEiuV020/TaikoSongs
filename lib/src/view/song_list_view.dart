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

  Future<List<SongItem>> initData(
      List<bool> visibleList, Map<String, bool> sortMap) {
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
            SongItem.makeComparator(sortMap),
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            TranslatedText(releaseItem.name),
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
        final sortMap = settings.sortMap.get();
        final lastSortKey = sortMap.keys.last;
        final lastSortOrder = sortMap[lastSortKey]!;
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        settings.sortMap.use((sortMap) {
                          const key = 'category';
                          final oldValue = sortMap.remove(key) ?? false;
                          sortMap[key] = !oldValue;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    '曲名${getSortOrderCharacter('category', lastSortKey, lastSortOrder)}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: settings.visibleColumnList.get()[1],
                    child: InkWell(
                      onTap: () {
                        settings.sortMap.use((sortMap) {
                          const key = 'bpm';
                          final oldValue = sortMap.remove(key) ?? false;
                          sortMap[key] = !oldValue;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                            'BPM${getSortOrderCharacter('bpm', lastSortKey, lastSortOrder)}'),
                      ),
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
                        settings.sortMap.use((sortMap) {
                          final key = DifficultyItem
                              .difficultyTypeStringMap[e]!;
                          final oldValue = sortMap.remove(key) ?? false;
                          sortMap[key] = !oldValue;
                        });
                      },
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: Container(
                          color: Color(0x88000000 |
                          DifficultyItem
                              .difficultyTypeColorMap[e]!),
                          child: Center(
                                    child: DifficultyItem
                                                .difficultyTypeStringMap[e]! ==
                                            lastSortKey
                                        ? Text(getSortOrderCharacter(
                                            DifficultyItem
                                                .difficultyTypeStringMap[e]!,
                                            lastSortKey,
                                            lastSortOrder,
                                          ))
                                        : Text(
                                            DifficultyItem
                                                .difficultyTypeStringMap[e]!
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
                future: initData(
                    settings.visibleColumnList.get(), settings.sortMap.get()),
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
                                  : Color(0x22ffffff & item.categoryColor!),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        TranslatedText(item.name),
                                        Visibility(
                                          visible: item.subtitle.isNotEmpty &&
                                              settings.visibleColumnList
                                                  .get()[0],
                                          child: TranslatedText(
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

  String getSortOrderCharacter(
      String key, String lastSortKey, bool lastSortOrder) {
    if (key != lastSortKey) {
      return '';
    }
    String orderString;
    if (lastSortOrder) {
      orderString = '▼';
    } else {
      orderString = '▲';
    }
    if (key == 'category') {
      return ' 类型$orderString';
    }
    return orderString;
  }
}
