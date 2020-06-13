import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthytrivia/providers/auth_provider.dart';
import 'package:healthytrivia/providers/theme_provider.dart';
import 'package:healthytrivia/screens/auth_screen.dart';
import 'package:healthytrivia/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      bool isLightTheme = prefs.getBool('isLightTheme') ?? true;
      runApp(MyApp(isLightTheme: isLightTheme));
    });
  });
}

class MyApp extends StatelessWidget {
  MyApp({this.isLightTheme});

  final bool isLightTheme;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(isLightTheme: isLightTheme),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Healthy Trivia',
            theme: themeProvider.getThemeData,
            home: AuthManager(title: 'Healthy Trivia'),
          );
        },
      ),
    );
  }
}

class AuthManager extends StatelessWidget {
  AuthManager({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: true);

    if (authProvider.isAuthenticated) {
      return HomeScreen();
    } else {
      return AuthScreen();
    }
  }
}
