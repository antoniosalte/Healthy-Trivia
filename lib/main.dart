import 'package:flutter/material.dart';
import 'package:healthytrivia/providers/auth_provider.dart';
import 'package:healthytrivia/providers/theme_provider.dart';
import 'package:healthytrivia/screens/auth_screen.dart';
import 'package:healthytrivia/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(isLightTheme: true),
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
