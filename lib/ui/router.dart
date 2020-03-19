import 'package:flutter/material.dart';
import 'package:habits_plus/ui/view/create_habit.dart';
import 'package:habits_plus/ui/view/login.dart';
import 'package:habits_plus/ui/view/shell.dart';
import 'package:habits_plus/ui/view/signup.dart';

const String initialRoute = 'login';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print(settings.name);
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MainShell());
      // case 'loading'
      // return MaterialPageRouter(builder: (_) => )
      case 'login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case 'signup':
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case 'create':
        return MaterialPageRoute(builder: (_) => CreateHabitPage());
      default:
        return MaterialPageRoute(builder: (_) => MainShell());
    }
  }
}
