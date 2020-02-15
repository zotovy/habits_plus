import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/models/theme.dart';
import 'package:habits_plus/models/userData.dart';
import 'package:habits_plus/services/auth.dart';
import 'package:habits_plus/services/database.dart';
import 'package:habits_plus/ui/create_habit.dart';
import 'package:habits_plus/ui/home.dart';
import 'package:habits_plus/ui/intro.dart';
import 'package:habits_plus/ui/login.dart';
import 'package:habits_plus/ui/signup.dart';
import 'package:habits_plus/util/constant.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'localization.dart';

void main() {
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

class MainApp extends StatelessWidget {
  const MainApp({Key key}) : super(key: key);

  Widget _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: FlutterLogo(size: 100),
      ),
    );
  }

  Widget _getPage(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        try {
          String id = snapshot.data.uid;
          Provider.of<UserData>(context).currentUserId = id;
          return FutureBuilder(
            future: DatabaseServices.getAllHabitsById(id),
            builder: (BuildContext context, futureSnapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return _buildLoadingScreen(context);
                default:
                  if (snapshot.hasError)
                    return Container(
                      child: Text(snapshot.error),
                    );
                  else {
                    if (futureSnapshot.data != null) {
                      return HomePage(futureSnapshot.data);
                    } else if (futureSnapshot.hasData) {
                      return HomePage([]);
                    } else {
                      return _buildLoadingScreen(context);
                    }
                  }
              }
            },
          );
        } catch (e) {
          return IntroPage();
        }
        // return _buildLoadingScreen(context);
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
      home: _getPage(context),
      routes: {
        LoginPage.id: (_) => LoginPage(),
        SignUpPage.id: (_) => SignUpPage(),
        CreateHabitPage.id: (_) => CreateHabitPage(),
      },
    );
  }
}
