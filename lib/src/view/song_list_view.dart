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
            return ListView.builder(
              restorationId: 'songList',
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index];

                return ListTile(
                    title: Text(
                        "${item.name}\t ${item.category}\t ${item.bpm}\t ${item.difficultyMap.values}"),
                    leading: const CircleAvatar(
                      foregroundImage:
                          AssetImage('assets/images/flutter_logo.png'),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        DifficultyDetailView.routeName,
                        arguments: item.difficultyMap.values.last,
                      );
                    });
              },
            );
          }),
    );
  }
}
