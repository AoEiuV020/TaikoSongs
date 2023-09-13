import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:taiko_songs/src/db/data.dart';

import '../settings/settings_view.dart';
import 'song_list_view.dart';
import 'translated_text_view.dart';

class ReleaseListView extends StatelessWidget {
  ReleaseListView({
    super.key,
  });

  static const routeName = '/release_list';
  final logger = Logger('ReleaseListView');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('作品列表'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: DataSource().getReleaseList().toList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              logger.severe(
                  'initData failed', snapshot.error, snapshot.stackTrace);
              return const Text('Error!');
            }
            var items = snapshot.requireData;
            return Scrollbar(
              interactive: true,
              child: ListView.builder(
                restorationId: 'releaseList',
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];

                  return ListTile(
                      title: TranslatedText(item.name),
                      onTap: () {
                        Navigator.restorablePushNamed(
                          context,
                          SongListView.routeName,
                          arguments: item.toJson(),
                        );
                      });
                },
              ),
            );
          }),
    );
  }
}
