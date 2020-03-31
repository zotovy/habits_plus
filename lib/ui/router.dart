import 'package:flutter/material.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/ui/view/create_habit.dart';
import 'package:habits_plus/ui/view/detail_habit.dart';
import 'package:habits_plus/ui/view/home.dart';
import 'package:habits_plus/ui/view/image_preview.dart';
import 'package:habits_plus/ui/view/login.dart';
import 'package:habits_plus/ui/view/shell.dart';
import 'package:habits_plus/ui/view/signup.dart';

const String initialRoute = 'login';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
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
      case 'home':
        return MaterialPageRoute(builder: (_) => HomePage());
      case 'habit_detail':
        Habit _habit = settings.arguments;
        return MaterialPageRoute(builder: (_) => DetailHabitPage(_habit));
      case 'image_preview':
        List _arg = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => ImagePreviewPage(
            image: _arg[0],
            tag: _arg[1],
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => MainShell());
    }
  }
}
