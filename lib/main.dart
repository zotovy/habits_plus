import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habits_plus/core/models/app_settings.dart';
import 'package:habits_plus/core/models/theme.dart';
import 'package:habits_plus/core/models/userData.dart';
import 'package:habits_plus/core/services/database.dart';
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
  runApp(MyApp());
}

final _flareLoginFiles = [
  AssetFlare(bundle: rootBundle, name: "assets/flare/intro_1.flr"),
  AssetFlare(bundle: rootBundle, name: "assets/flare/intro_2.flr"),
  AssetFlare(bundle: rootBundle, name: "assets/flare/intro_3.flr"),
  AssetFlare(bundle: rootBundle, name: "assets/flare/start.flr"),
];

final _flareMainFiles = [
  AssetFlare(bundle: rootBundle, name: "assets/flare/darkmode.flr"),
  AssetFlare(bundle: rootBundle, name: "assets/flare/circleLoading.flr"),
];

Future<bool> setupLoginFlare() async {
  for (final filename in _flareLoginFiles) {
    await cachedActor(filename);
  }
  return true;
}

Future<bool> setupMainFlare() async {
  for (final filename in _flareMainFiles) {
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
          create: (_) => ThemeModel(),
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
  ThemeModel theme;

  // Widget _getPage(BuildContext context) {
  //   // FirebaseAuth.instance
  //   return StreamBuilder<FirebaseUser>(
  //     stream: FirebaseAuth.instance.onAuthStateChanged,
  //     builder: (BuildContext context, snapshot) {
  //       // print(snapshot.data);

  //       try {
  //         String id = snapshot.data.uid;
  //         Provider.of<UserData>(context).currentUserId = id;
  //         locator<HomeViewModel>().fetch();
  //         locator<DrawerViewModel>().fetchUser();
  //         return MainShell();
  //       } catch (e) {
  //         return IntroPage();
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    theme = Provider.of<ThemeModel>(context);

    return FutureBuilder(
      future: locator<DatabaseServices>().setupApp(),
      // selector: (context, model) => model.isDarkMode,
      builder: (_, AsyncSnapshot<AppSettings> snap) {
        if (snap.connectionState == ConnectionState.done) {
          if (snap.data.isDarkMode) {
            theme.setMode(true);
          }

          return MaterialApp(
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
            theme: lightMode,
            darkTheme: darkMode,
            themeMode: snap.data.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: Builder(
              builder: (context) {
                if (snap.data.isUserLogin == true) {
                  locator<HomeViewModel>().fetch();
                  locator<DrawerViewModel>().fetchUser();
                  return FutureBuilder(
                    future: setupMainFlare(),
                    builder: (_, snap2) {
                      return snap2.hasData ? MainShell() : LoadingPage();
                    },
                  );
                } else if (snap.data == false) {
                  return FutureBuilder(
                    future: setupLoginFlare(),
                    builder: (_, snap2) {
                      return snap2.hasData ? IntroPage() : LoadingPage();
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
        } else {
          return MaterialApp(
            theme: lightMode,
            home: LoadingPage(),
          );
        }
      },
    );
  }
}
