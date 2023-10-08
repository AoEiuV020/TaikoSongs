import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:taiko_songs/src/bean/difficulty.dart';
import 'package:taiko_songs/src/bean/release.dart';
import 'package:taiko_songs/src/bean/song.dart';
import 'package:taiko_songs/src/calc/song_calculator.dart';
import 'package:taiko_songs/src/compare/then_compare.dart';
import 'package:taiko_songs/src/db/data.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../settings/settings_controller.dart';
import '../settings/settings_view.dart';
import 'difficulty_detail_view.dart';
import 'translated_text_view.dart';

class SongListView extends StatefulWidget {
  const SongListView._(
      {required this.title,
      this.url,
      required this.dataProvider,
      this.keyword = ''});

  static const routeName = '/song_list';

  factory SongListView.fromReleaseItem(ReleaseItem releaseItem) {
    return SongListView._(
      title: releaseItem.name,
      url: releaseItem.url,
      dataProvider: () => DataSource().getSongList(releaseItem),
    );
  }

  factory SongListView.fromSearch(SearchSongListArgument args) {
    final releaseItem = args.releaseItem;
    return SongListView._(
      title: releaseItem.name,
      url: releaseItem.url,
      dataProvider: () => DataSource().getSongList(releaseItem),
      keyword: args.keyword,
    );
  }

  factory SongListView.fromCalculator(CalculatorArgument argument) {
    return SongListView._(
      title: '计算结果',
      dataProvider: () => argument.getStream(),
    );
  }

  final String title;
  final String? url;
  final Stream<SongItem> Function() dataProvider;
  final String keyword;

  @override
  State<SongListView> createState() => _SongListViewState();
}

class SearchSongListArgument {
  final ReleaseItem releaseItem;
  final String keyword;

  SearchSongListArgument(this.releaseItem, this.keyword);
}

class _SongListViewState extends State<SongListView> {
  final logger = Logger('SongListView');

  final ScrollController _scrollController = ScrollController();

  List<SongItem>? _data;
  List<SongItem>? _showingData;
  String keyword = '';

  Future<List<SongItem>> initDataCache() async {
    var data = _data;
    if (data == null) {
      logger.info('make data');
      data = await widget.dataProvider().toList();
      setState(() {
        _data = data;
      });
    }
    return data;
  }

  Stream<SongItem> filter(
      List<SongItem> data, List<bool> visibleList, String keyword) async* {
    final keywordList = keyword.split(' ');
    final ds = DataSource();
    for (final song in data) {
      var difficultyExists = false;
      for (var i = 0; i < 5; ++i) {
        final visibleIndex = i + 2;
        final visible = visibleList[visibleIndex];
        if (!visible) {
          continue;
        }
        final level = song.getLevelTypeDifficulty(DifficultyType.values[i]);
        if (level > 0) {
          difficultyExists = true;
        }
      }
      if (!difficultyExists) {
        continue;
      }
      if (keyword.isEmpty) {
        yield song;
        continue;
      }
      var nameMatch = true;
      for (final key in keywordList) {
        if (!await ds.textContains(song.name, key) &&
            !await ds.textContains(song.subtitle, key)) {
          nameMatch = false;
          break;
        }
      }
      if (nameMatch) {
        yield song;
      }
    }
  }

  Future<List<SongItem>> initData(
      List<bool> visibleList, Map<String, bool> sortMap) async {
    _showingData = null;
    var data = await initDataCache();
    data = await filter(data, visibleList, keyword).toList();
    if (sortMap.isNotEmpty) {
      data.sort(
        SongItem.makeComparator(sortMap).then(basicComparing(data)),
      );
    }
    _showingData = data;
    return data;
  }

  void search(BuildContext context, String text) {
    setState(() {
      keyword = text;
    });
  }

  @override
  void initState() {
    super.initState();
    keyword = widget.keyword;
    initDataCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TranslatedText(
          widget.title,
          overflow: TextOverflow.fade,
        ),
        actions: [
          Visibility(
            visible: _data != null,
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final TextEditingController textEditingController =
                        TextEditingController();
                    textEditingController.text = keyword;
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
                        decoration:
                            const InputDecoration(labelText: '空格分隔多个关键字'),
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
          ),
          Visibility(
            visible: widget.url != null,
            child: IconButton(
              icon: const Icon(Icons.open_in_browser),
              onPressed: () {
                launchUrlString(widget.url!);
              },
            ),
          ),
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
        final lastSortKey = sortMap.keys.lastOrNull ?? '';
        final lastSortOrder = lastSortKey == '' ? true : sortMap[lastSortKey]!;
        return FutureBuilder(
            future: initData(
                settings.visibleColumnList.get(), settings.sortMap.get()),
            builder: (context, snapshot) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          '曲名${getSearchText()}${getSongCountText()}${getSortOrderCharacter('category', lastSortKey, lastSortOrder)}'),
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
                                        final oldValue =
                                            sortMap.remove(key) ?? false;
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
                                                          .difficultyTypeStringMap[
                                                      e]! ==
                                                  lastSortKey
                                              ? Text(getSortOrderCharacter(
                                                  DifficultyItem
                                                      .difficultyTypeStringMap[e]!,
                                                  lastSortKey,
                                                  lastSortOrder,
                                                ))
                                              : Text(
                                                  DifficultyItem
                                                      .difficultyTypeStringMap[
                                                          e]!
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
                  _data == null
                      ? const CircularProgressIndicator()
                      : Builder(builder: (context) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            logger.severe('initData failed', snapshot.error,
                                snapshot.stackTrace);
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
                                              onTap: item.difficultyMap
                                                      .containsKey(e)
                                                  ? () {
                                                      Navigator
                                                          .restorablePushNamed(
                                                        context,
                                                        DifficultyDetailView
                                                            .routeName,
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
                                                              .difficultyTypeColorMap[
                                                          e]!),
                                                  child: Center(
                                                    child: Text(
                                                      getDifficultyString(item
                                                          .getLevelTypeDifficulty(
                                                              e)),
                                                      textAlign:
                                                          TextAlign.center,
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
                                          : Color(
                                              0x22ffffff & item.categoryColor!),
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TranslatedText(item.name),
                                                Visibility(
                                                  visible: item.subtitle
                                                          .isNotEmpty &&
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
                                            visible: settings.visibleColumnList
                                                .get()[1],
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
            });
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
      return '-类型$orderString';
    }
    return orderString;
  }

  String getDifficultyString(int level) {
    if (level == 0) {
      return '-';
    }
    return level.toString();
  }

  String getSongCountText() {
    if (_showingData != null) {
      return '-共${_showingData!.length}首';
    }
    final data = _data;
    if (data == null || data.isEmpty) {
      return '';
    }
    return '-共${data.length}首';
  }

  String getSearchText() {
    if (keyword.isEmpty) {
      return '';
    }
    return '-$keyword';
  }
}
