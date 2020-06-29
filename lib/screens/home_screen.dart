import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthytrivia/providers/theme_provider.dart';
import 'package:healthytrivia/screens/difficulty_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
    );
  }

  void goToGame() {
    _showLoading();
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DifficultyScreen()),
    );
  }

  Future<void> setTheme() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    await themeProvider.setThemeDataAsync(!themeProvider.isLightTheme);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(8, 32, 8, 32),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(themeProvider.isLightTheme
                    ? Icons.brightness_3
                    : Icons.brightness_7),
                onPressed: setTheme,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                height: 150,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                child: Text(
                  'JUGAR',
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onPressed: goToGame,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
