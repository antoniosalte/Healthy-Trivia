import 'dart:async';
import 'package:quiver/async.dart';
import 'package:flutter/material.dart';
import 'package:healthytrivia/models/question.dart';
import 'package:healthytrivia/screens/information_screen.dart';
import 'package:healthytrivia/screens/score_screen.dart';
import 'package:healthytrivia/services/singleton.dart';

enum GamePhase { question, result }

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Singleton _singleton = Singleton();
  int _questionIndex = -1;
  int _answerIndex;
  Question _question;
  GamePhase gamePhase = GamePhase.question;

  CountdownTimer _countdownTimer;
  StreamSubscription _subscription;
  int _countDownDuration = 20;
  int _timeRemaining = 20;

  String _username = 'dummy';

  @override
  void initState() {
    getQuestion();
    super.initState();
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  void startTimer() {
    _countdownTimer = new CountdownTimer(
      new Duration(seconds: _countDownDuration),
      new Duration(seconds: 1),
    );

    _subscription = _countdownTimer.listen(null);
    _subscription.onData((data) {
      setState(() {
        _timeRemaining = _countdownTimer.remaining.inSeconds;
      });
    });
    _subscription.onDone(() async {
      await answerQuestion(-1);
      cancelTimer();
    });
  }

  void cancelTimer() {
    _subscription.cancel();
    _countdownTimer.cancel();
  }

  void openInformation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InformationScreen(
          url: _question.information,
        ),
      ),
    );
  }

  Future<void> endGame() async {
    print(_username);
    await _singleton.endGame(_username);
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreScreen(
          score: _singleton.score,
          username: _username,
        ),
      ),
    );
  }

  Future<void> _showUsernameDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Username'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  setState(() {
                    _username = value;
                  });
                },
              )
            ],
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('Guardar'),
              onPressed: endGame,
            )
          ],
        );
      },
    );
  }

  void getQuestion() {
    setState(() {
      _questionIndex += 1;
      _answerIndex = null;
      _question = _singleton.getQuestion();
      _timeRemaining = 20;
      gamePhase = GamePhase.question;
    });
    startTimer();
  }

  Future<void> answerQuestion(int value) async {
    cancelTimer();
    setState(() {
      _answerIndex = value;
      gamePhase = GamePhase.result;
    });
    await _singleton.answerQuestion(
        _answerIndex, (_countDownDuration - _timeRemaining));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GameScreen'),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Text('Pregunta ${_questionIndex + 1}'),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Text('Tiempo: $_timeRemaining'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Card(
              elevation: 10.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    color: Theme.of(context).colorScheme.secondary,
                    height: 50,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(_question.question),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 200,
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: (gamePhase == GamePhase.question
                        ? _buildQuestion()
                        : _buildResult()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[_buildOptions()],
    );
  }

  Widget _buildOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _question.options
          .asMap()
          .entries
          .map(
            (entry) => RadioListTile<int>(
              title: Text(entry.value),
              value: entry.key,
              groupValue: _answerIndex,
              onChanged: (int value) {
                answerQuestion(value);
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildResult() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child:
              Text(_answerIndex == _question.answerIndex ? 'Correcto' : 'Mal'),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text('Saber Más'),
                onPressed: openInformation,
              ),
              _buildAction(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAction() {
    return ((_questionIndex + 1) == _singleton.questionLength
        ? RaisedButton(
            child: Text('Puntaje'),
            onPressed: _showUsernameDialog,
          )
        : RaisedButton(
            child: Text('Siguiente'),
            onPressed: getQuestion,
          ));
  }
}
