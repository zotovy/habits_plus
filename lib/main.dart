import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/flare_cache_asset.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habits_plus/core/models/theme.dart';
import 'package:habits_plus/core/models/userData.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/util/habit_templates.dart';
import 'package:habits_plus/core/viewmodels/drawer_model.dart';
import 'package:habits_plus/core/viewmodels/home_model.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/ui/router.dart';
import 'package:habits_plus/ui/view/intro.dart';
import 'package:habits_plus/ui/view/loading.dart';
import 'package:habits_plus/ui/view/shell.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'localization.dart';

void main() {
  // Newer versions of Flutter require initializing widget-flutter binding
  // prior to warming up the cache.
  WidgetsFlutterBinding.ensureInitialized();

  // Don't prune the Flare cache, keep loaded Flare files warm and ready
  // to be re-displayed.
  FlareCache.doesPrune = false;

  setupLocator();
  setupFlare().then((_) {
    runApp(MyApp());
  });
}

final _filesToWarmup = [
  AssetFlare(bundle: rootBundle, name: "assets/flare/intro_1.flr"),
  AssetFlare(bundle: rootBundle, name: "assets/flare/intro_2.flr"),
  AssetFlare(bundle: rootBundle, name: "assets/flare/intro_3.flr"),
  AssetFlare(bundle: rootBundle, name: "assets/flare/start.flr"),
];

Future<bool> setupFlare() async {
  for (final filename in _filesToWarmup) {
    await cachedActor(filename);
  }
  return true;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeModel>(
          create: (_) => darkMode,
        ),
        ChangeNotifierProvider<UserData>(
          create: (_) => UserData(),
        ),
      ],
      child: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Widget _getPage(BuildContext context) {
    // FirebaseAuth.instance
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        // print(snapshot.data);

        try {
          String id = snapshot.data.uid;
          Provider.of<UserData>(context).currentUserId = id;
          locator<HomeViewModel>().fetch();
          locator<DrawerViewModel>().fetchUser();
          return MainShell();
        } catch (e) {
          return IntroPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context).getTheme();
    return MaterialApp(
      theme: theme,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ru', 'RU'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // home: _getPage(context),
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        print('Not supported location $locale. Choose EN');
        return supportedLocales.first;
      },
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: locator<DatabaseServices>().setupSharedPrefferences(),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.done &&
              snap.data == true) {
            // String id = snap.data.uid;
            // Provider.of<UserData>(context, listen: false).currentUserId = id;
            locator<HomeViewModel>().fetch();
            locator<DrawerViewModel>().fetchUser();
            return MainShell();
          } else if (snap.connectionState == ConnectionState.done &&
              snap.data == false) {
            return FutureBuilder(
              future: setupFlare(),
              builder: (_, snap) {
                return snap.hasData ? IntroPage() : LoadingPage();
              },
            );
          }
          return LoadingPage();
        },
      ),
      // home: FutureBuilder(
      //   future: setupFlare(),
      //   builder: (_, snap) {
      //     return snap.hasData ? IntroPage() : LoadingPage();
      //   },
      // ),
      title: 'Habits+',
      onGenerateRoute: (RouteSettings settings) =>
          Router.generateRoute(settings, context),
      // initialRoute: 'login',
    );
  }
}
