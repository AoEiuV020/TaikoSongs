import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:taiko_songs/src/bean/difficulty.dart';
import 'package:taiko_songs/src/bean/release.dart';
import 'package:taiko_songs/src/calc/song_calculator.dart';
import 'package:taiko_songs/src/view/calculator_view.dart';

import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'view/difficulty_detail_view.dart';
import 'view/release_list_view.dart';
import 'view/song_list_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return Consumer<SettingsController>(
      builder: (context, settings, child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settings.themeMode.get(),

          builder: EasyLoading.init(),

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                final args = routeSettings.arguments;
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return const SettingsView();
                  case CalculatorView.routeName:
                    return const CalculatorView();
                  case SongListView.routeName:
                    if (args is CalculatorArgument) {
                      return SongListView.fromCalculator(args);
                    } else {
                      return SongListView.fromReleaseItem(
                        ReleaseItem.fromJson(args as Map<String, dynamic>),
                      );
                    }
                  case DifficultyDetailView.routeName:
                    return DifficultyDetailView(
                      difficultyItem:
                          DifficultyItem.fromJson(args as Map<String, dynamic>),
                    );
                  case ReleaseListView.routeName:
                  default:
                    return ReleaseListView();
                }
              },
            );
          },
        );
      },
    );
  }
}
