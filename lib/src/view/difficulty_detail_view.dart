import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
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
        title: const Text('谱面'),
      ),
      body: FutureBuilder(
          future: DataSource().getDifficulty(difficultyItem),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              logger.severe(
                  'initData failed', snapshot.error, snapshot.stackTrace);
              return const Text('Error!');
            }
            var difficulty = snapshot.requireData;
            return SizedBox(
              width: double.infinity, // 宽度充满父级容器
              height: double.infinity, // 高度充满父级容器
              child: SingleChildScrollView(
                child: Image.network(
                  difficulty.chartImageUrl,
                  fit: BoxFit.fitWidth,
                ),
              ),
            );
          }),
    );
  }
}
