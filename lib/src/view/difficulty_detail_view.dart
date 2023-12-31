import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../bean/difficulty.dart';
import '../db/data.dart';
import 'web_cors_error_tip.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () {
              launchUrlString(difficultyItem.url);
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: DataSource().getDifficulty(difficultyItem),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              logger.severe(
                  'initData failed', snapshot.error, snapshot.stackTrace);
              if (snapshot.error is DioException && kIsWeb) {
                return WebCorsErrorTip(originUrl: difficultyItem.url);
              }
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
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Row(
                      children: [
                        CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ],
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Row(
                      children: [
                        const Text('Error!'),
                        Text(error.toString()),
                      ],
                    );
                  },
                ),
              ),
            );
          }),
    );
  }
}
