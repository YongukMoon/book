import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'package:book/screens/splash/SplashPage.dart';
import 'package:book/screens/splash/SignInPage.dart';
import 'package:book/screens/HomePage.dart';

Future main() async {
  await DotEnv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      initialRoute: SplashPage.routeName,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case HomePage.routeName:
            {
              return MaterialPageRoute(
                  builder: (context) => HomePage(
                        user: (settings.arguments as Map)['user'],
                        books: (settings.arguments as Map)['books'],
                      ));
            }
            break;

          case SignInPage.routeNmae:
            {
              return MaterialPageRoute(
                  builder: (context) => SignInPage(
                        books: settings.arguments,
                      ));
            }
            break;

          default:
            {
              return MaterialPageRoute(builder: (context) => SplashPage());
            }
            break;
        }
      },
    );
  }
}
