import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/models/theme.dart';
import 'package:habits_plus/core/models/userData.dart';
import 'package:habits_plus/core/util/habit_templates.dart';
import 'package:habits_plus/core/viewmodels/drawer_model.dart';
import 'package:habits_plus/core/viewmodels/home_model.dart';
import 'package:habits_plus/locator.dart';
import 'package:habits_plus/ui/router.dart';
import 'package:habits_plus/ui/view/intro.dart';
import 'package:habits_plus/ui/view/loading.dart';
import 'package:habits_plus/ui/view/login.dart';
import 'package:habits_plus/ui/view/shell.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'localization.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeModel>(
          create: (_) => lightMode,
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
          locator<HomeViewModel>().fetch(id);
          locator<DrawerViewModel>().fetchUser(id);
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
        future: FirebaseAuth.instance.currentUser(),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.done &&
              snap.data != null) {
            String id = snap.data.uid;
            Provider.of<UserData>(context, listen: false).currentUserId = id;
            locator<HomeViewModel>().fetch(id);
            locator<DrawerViewModel>().fetchUser(id);
            return MainShell();
          } else if (snap.connectionState == ConnectionState.done &&
              snap.data == null) {
            return LoginPage();
          }
          return LoadingPage();
        },
      ),
      title: 'Habits+',
      onGenerateRoute: (RouteSettings settings) =>
          Router.generateRoute(settings, context),
      // initialRoute: 'login',
    );
  }
}
