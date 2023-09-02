import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:taiko_songs/src/bean/difficulty.dart';
import 'package:taiko_songs/src/db/data.dart';

class DifficultyDetailView extends StatelessWidget {
  DifficultyDetailView({super.key, required this.difficultyItem});

  static const routeName = '/difficulty_detail';

  final DifficultyItem difficultyItem;
  final logger = Logger('DifficultyDetailView');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: FutureBuilder(
          future: DataSource(Directory(
                  path.join(Directory.systemTemp.path, 'taiko_songs')))
              .getDifficulty(difficultyItem),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              logger.info('done');
            } else if (snapshot.hasError) {
              return const Text('Error!');
            }
            var difficulty = snapshot.requireData;
            return Image.network(difficulty.chartImageUrl);
          }),
    );
  }
}
