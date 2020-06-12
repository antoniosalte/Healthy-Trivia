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
                Theme.of(context).colorScheme.primary),
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(themeProvider.isLightTheme
                ? Icons.brightness_3
                : Icons.brightness_7),
            onPressed: () {
              themeProvider.setThemeData = !themeProvider.isLightTheme;
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 32, right: 32, top: 64, bottom: 48),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                height: 96,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                child: Text('Jugar'),
                onPressed: goToGame,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
