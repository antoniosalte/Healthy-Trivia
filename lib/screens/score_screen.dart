import 'dart:async';
import 'package:flutter/material.dart';

class ScoreScreen extends StatefulWidget {
  final int score;
  final String username;

  ScoreScreen({Key key, this.score, this.username}) : super(key: key);

  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  void goToHome() {
    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScoreScreen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.username),
            Text('Score'),
            Text('${widget.score}'),
            RaisedButton(
              child: Text('Home'),
              onPressed: goToHome,
            ),
          ],
        ),
      ),
    );
  }
}
