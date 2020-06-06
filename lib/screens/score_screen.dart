import 'package:flutter/material.dart';

class ScoreScreen extends StatefulWidget {
  final int score;

  ScoreScreen({Key key, this.score}) : super(key: key);

  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
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
            Text('Score'),
            Text('${widget.score}'),
          ],
        ),
      ),
    );
  }
}
