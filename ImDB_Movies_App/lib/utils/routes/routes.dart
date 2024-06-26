import 'package:flutter/material.dart';
import 'package:learning_mvvm/utils/routes/routes_name.dart';
import 'package:learning_mvvm/view/crash_logs.dart';
import 'package:learning_mvvm/view/home.dart';
import 'package:learning_mvvm/view/login.dart';
import 'package:learning_mvvm/view/network_logs.dart';
import 'package:learning_mvvm/view/no_route.dart';
import 'package:learning_mvvm/view/splash.dart';

import '../../view/signup.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (context) => SplashView(),
        );
      case RoutesName.login:
        return MaterialPageRoute(
          builder: (context) => LoginView(),
        );
      case RoutesName.home:
        return MaterialPageRoute(
          builder: (context) => HomeView(),
        );
      case RoutesName.signup:
        return MaterialPageRoute(
          builder: (context) => SignUpView(),
        );
      case RoutesName.networkLogs:
        return MaterialPageRoute(
          builder: (context) => NetworkLogs(),
        );
      case RoutesName.crashLogs:
        return MaterialPageRoute(
          builder: (context) => CrashLogs(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => FaultRouteView(),
        );
    }
  }
}
