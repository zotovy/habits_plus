import 'package:flutter/material.dart';
import 'package:habits_plus/ui/view/home.dart';
import 'package:habits_plus/ui/view/login.dart';
import 'package:habits_plus/ui/view/signup.dart';

const String initialRoute = 'login';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print(settings.name);
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      // case 'loading'
      // return MaterialPageRouter(builder: (_) => )
      case 'login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case 'signup':
        return MaterialPageRoute(builder: (_) => SignUpPage());
      default:
        return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}
