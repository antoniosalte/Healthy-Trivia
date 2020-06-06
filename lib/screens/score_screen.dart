import 'dart:async';
import 'package:flutter/material.dart';
import 'package:healthytrivia/models/ranking.dart';
import 'package:healthytrivia/services/singleton.dart';

class ScoreScreen extends StatefulWidget {
  final int score;
  final String username;

  ScoreScreen({Key key, this.score, this.username}) : super(key: key);

  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  Singleton _singleton = Singleton();
  List<Ranking> ranking = List<Ranking>();

  bool rankingBool = false;

  void goToHome() {
    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
  }

  Future<void> getRanking() async {
    if (ranking.length == 0) {
      ranking = await _singleton.getRanking();
    }
    setState(() {
      rankingBool = true;
    });
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
            (rankingBool ? _buildRanking() : _buildScore()),
            RaisedButton(
              child: Text('Home'),
              onPressed: goToHome,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScore() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(widget.username),
        Text('Score: ${widget.score}'),
        RaisedButton(
          child: Text('Ranking'),
          onPressed: getRanking,
        ),
      ],
    );
  }

  Widget _buildRanking() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ranking
              .asMap()
              .entries
              .map(
                (entry) =>
                    Text('${entry.value.username} - ${entry.value.score}'),
              )
              .toList(),
        ),
        RaisedButton(
          child: Text('Score'),
          onPressed: () {
            setState(() {
              rankingBool = false;
            });
          },
        ),
      ],
    );
  }
}
