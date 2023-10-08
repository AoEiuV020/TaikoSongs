import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:taiko_songs/src/db/data.dart';

import '../bean/release.dart';
import 'song_list_view.dart';
import 'translated_text_view.dart';

class SearchReleaseListView extends StatelessWidget {
  SearchReleaseListView({
    super.key,
    required this.keyword,
  });

  static const routeName = '/search_release_list';
  final logger = Logger('SearchReleaseListView');
  final ScrollController _scrollController = ScrollController();
  final String keyword;

  Stream<List<ReleaseItem>> initData() async* {
    final List<ReleaseItem> data = [];
    await for (final release in DataSource().search(keyword)) {
      data.add(release);
      yield data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('搜索结果'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: StreamBuilder(
            stream: initData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                logger.severe(
                    'initData failed', snapshot.error, snapshot.stackTrace);
                return const Text('Error!');
              }
              var items = snapshot.requireData;
              final done = snapshot.connectionState == ConnectionState.done;
              return Scrollbar(
                controller: _scrollController,
                interactive: true,
                child: ListView.builder(
                  restorationId: 'releaseList',
                  controller: _scrollController,
                  itemCount: items.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == items.length) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: done
                            ? Text(
                                '没有更多了',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              )
                            : const Row(
                                children: [
                                  CircularProgressIndicator(),
                                ],
                              ),
                      );
                    }
                    final item = items[index];

                    return ListTile(
                        title: TranslatedText(item.name),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            SongListView.routeName,
                            arguments: SearchSongListArgument(item, keyword),
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
