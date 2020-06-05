import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: Text('HomeScreen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Bienvenido'),
            RaisedButton(
              child: Text('Sign Out'),
              onPressed: () {
                authProvider.signOut();
              },
            ),
            RaisedButton(
              child: Text('Jugar'),
              onPressed: goToGame,
            )
          ],
        ),
      ),
    );
  }
}
