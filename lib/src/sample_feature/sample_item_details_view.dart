import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:taiko_songs/src/bean/difficulty.dart';
import 'package:taiko_songs/src/bean/release.dart';
import 'package:taiko_songs/src/db/data.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  SampleItemDetailsView({super.key, required this.releaseItem});

  static const routeName = '/sample_item';

  final ReleaseItem releaseItem;
  final logger = Logger('SampleItemDetailsView');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: FutureBuilder(
          future: DataSource(Directory(
                  path.join(Directory.systemTemp.path, 'taiko_songs')))
              .getSongList(releaseItem)
              .where((event) =>
                  event.getLevelTypeDifficulty(DifficultyType.uraOni) > 0)
              .toList()
              .then((value) => value
                ..sort(
                  (a, b) =>
                      a.getLevelTypeDifficulty(DifficultyType.uraOni) -
                      b.getLevelTypeDifficulty(DifficultyType.uraOni),
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
                      // Display the Flutter Logo image asset.
                      foregroundImage:
                          AssetImage('assets/images/flutter_logo.png'),
                    ),
                    onTap: () {
                      EasyLoading.showToast(item.subtitle);
                    });
              },
            );
          }),
    );
  }
}
