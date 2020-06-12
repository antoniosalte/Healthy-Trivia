import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthytrivia/providers/auth_provider.dart';
import 'package:healthytrivia/screens/difficulty_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void goToGame() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DifficultyScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: true);
    return Scaffold(
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
              alignment: Alignment.center,
              child: RaisedButton(
                child: Text('Sign Out'),
                onPressed: () {
                  authProvider.signOut();
                },
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
