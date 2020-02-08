import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/models/theme.dart';
import 'package:habits_plus/models/userData.dart';
import 'package:habits_plus/ui/home.dart';
import 'package:habits_plus/ui/intro.dart';
import 'package:habits_plus/ui/login.dart';
import 'package:habits_plus/ui/signup.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'localization.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget _getPage() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Provider.of<UserData>(context).currentUserId = snapshot.data.uid;
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeModel>(
          create: (_) => ThemeModel(ThemeData(
            primaryColor: Color(0xFF6C3CD1),
          )),
        ),
        ChangeNotifierProvider<UserData>(
          create: (_) => UserData(),
        ),
      ],
      child: MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({Key key}) : super(key: key);

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
      title: 'Habits+',
      home: IntroPage(),
      routes: {
        HomePage.id: (_) => HomePage(),
        LoginPage.id: (_) => LoginPage(),
        SignUpPage.id: (_) => SignUpPage(),
      },
    );
  }
}
