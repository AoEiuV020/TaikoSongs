import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:taiko_songs/src/db/data.dart';

import '../settings/settings_view.dart';
import 'song_list_view.dart';

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
        title: const Text('Sample Items'),
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
          future: DataSource(Directory(
                  path.join(Directory.systemTemp.path, 'taiko_songs')))
              .getReleaseList()
              .toList(),
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
              restorationId: 'releaseList',
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index];

                return ListTile(
                    title: Text(item.name),
                    leading: const CircleAvatar(
                      foregroundImage:
                          AssetImage('assets/images/flutter_logo.png'),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        SongListView.routeName,
                        arguments: item,
                      );
                    });
              },
            );
          }),
    );
  }
}
