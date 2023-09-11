import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:taiko_songs/src/bean/difficulty.dart';
import 'package:taiko_songs/src/bean/release.dart';
import 'package:taiko_songs/src/db/data.dart';
import 'package:taiko_songs/src/view/difficulty_detail_view.dart';

class SongListView extends StatelessWidget {
  SongListView({super.key, required this.releaseItem});

  static const routeName = '/song_list';

  final ReleaseItem releaseItem;
  final logger = Logger('SongListView');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: FutureBuilder(
          future: DataSource()
              .getSongList(releaseItem)
              .toList()
              .then((value) => value
                ..sort(
                  (a, b) =>
                      a.getLevelTypeDifficulty(DifficultyType.oni) -
                      b.getLevelTypeDifficulty(DifficultyType.oni),
                )),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              logger.info('done');
            } else if (snapshot.hasError) {
              return const Text('Error!');
            }
            var items = snapshot.requireData;
            return Scrollbar(
              interactive: true,
              child: ListView.builder(
                restorationId: 'songList',
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];

                  final Widget difficultyGroup = Row(
                    children: DifficultyType.values
                        .map((e) => InkWell(
                              onTap: item.difficultyMap.containsKey(e)
                                  ? () {
                                      Navigator.restorablePushNamed(
                                        context,
                                        DifficultyDetailView.routeName,
                                        arguments:
                                            item.difficultyMap[e]!.toJson(),
                                      );
                                    }
                                  : null,
                              child: SizedBox(
                                width: 32,
                                height: 32,
                                child: Center(
                                  child: Text(
                                    item.getLevelTypeDifficulty(e).toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  );
                  return InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name),
                                Visibility(
                                  visible: item.subtitle.isNotEmpty,
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
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Text(item.bpm),
                          ),
                          difficultyGroup,
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
    );
  }
}
