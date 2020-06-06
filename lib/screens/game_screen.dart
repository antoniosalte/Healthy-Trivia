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
              child: Text('Score'),
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
      body: Center(
        child: (gamePhase == GamePhase.question
            ? _buildQuestion()
            : _buildResult()),
      ),
    );
  }

  Widget _buildQuestion() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Tiempo: $_timeRemaining'),
        Text('Pregunta ${_questionIndex + 1}'),
        Text(_question.question),
        _buildOptions()
      ],
    );
  }

  Widget _buildOptions() {
    return Column(
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(_answerIndex == _question.answerIndex ? 'Correcto' : 'Mal'),
        RaisedButton(
          child: Text('Information'),
          onPressed: openInformation,
        ),
        _buildAction(),
      ],
    );
  }

  Widget _buildAction() {
    return ((_questionIndex + 1) == _singleton.questionLength
        ? RaisedButton(
            child: Text('Score'),
            onPressed: _showUsernameDialog,
          )
        : RaisedButton(
            child: Text('Next'),
            onPressed: getQuestion,
          ));
  }
}
