import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:appmedicolaluz/bloc/main_provider.dart';
import 'package:appmedicolaluz/user_preferences/user_preferences.dart';
import 'package:appmedicolaluz/routes.dart';
import 'package:appmedicolaluz/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();
  await prefs.initPrefs();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  String _initialRoute(dynamic token) {
    if (token.toString().isNotEmpty) {
      return loggedInitialRoute;
    } else {
      return noLoggedInitialRoute;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    final prefs = new UserPreferences();
    return MainProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Clinica La Luz',
        theme: theme(),
        // home: SplashScreen(),
        initialRoute: _initialRoute(prefs.token),
        routes: routes,
      ),
    );
  }
}
