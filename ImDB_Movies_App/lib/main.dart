import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:learning_mvvm/utils/routes/routes.dart';
import 'package:learning_mvvm/utils/routes/routes_name.dart';
import 'package:learning_mvvm/viewModel/auth_view_model.dart';
import 'package:learning_mvvm/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:quash_assignment/quash_assignment.dart';
import 'package:quash_assignment/screenshot_widget.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  runZonedGuarded(() async {
    await CrashLogger.initLogger();
    runApp(MVVM());
  }, (error, stackTrace) {
    CrashLogger.logError(error, stackTrace);
  });
}

class MVVM extends StatelessWidget {
  const MVVM({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserViewModel(),
        ),
      ],
      child: ScreenshotWidget(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Movies App (MVVM Architecture)',
          theme: ThemeData.dark(),
          initialRoute: RoutesName.splash,
          onGenerateRoute: Routes.generateRoute,
        ),
      ),
    );
  }
}
