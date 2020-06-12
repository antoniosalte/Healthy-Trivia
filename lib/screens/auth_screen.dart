import 'package:flutter/material.dart';
import 'package:healthytrivia/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: true);
    authProvider.signInAnonymously();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              'Loading',
            )
          ],
        ),
      ),
    );
  }
}
