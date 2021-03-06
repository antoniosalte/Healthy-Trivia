import 'dart:async';
import 'package:healthytrivia/models/ranking.dart';
import 'package:quiver/async.dart';
import 'package:flutter/material.dart';
import 'package:healthytrivia/models/question.dart';
import 'package:healthytrivia/screens/information_screen.dart';
import 'package:healthytrivia/screens/score_screen.dart';
import 'package:healthytrivia/services/game_service.dart';

enum GamePhase { question, result }

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameService _gameService = GameService();
  int _questionIndex = -1;
  int _answerIndex;
  int _score = 0;
  Question _question;
  GamePhase gamePhase = GamePhase.question;

  CountdownTimer _countdownTimer;
  StreamSubscription _subscription;
  int _countDownDuration = 20;
  int _timeRemaining = 20;

  String _nickname = 'dummy';

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
    _showLoading();
    Ranking currentRanking = _gameService.createRanking(_nickname);
    await _gameService.endGame(_nickname);
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreScreen(
          currentRanking: currentRanking,
        ),
      ),
    );
  }

  Future<void> _showNicknameDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nickname'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  setState(() {
                    _nickname = value;
                  });
                },
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
      _question = _gameService.getQuestion();
      _timeRemaining = 20;
      gamePhase = GamePhase.question;
    });
    startTimer();
  }

  Future<void> answerQuestion(int value) async {
    if (_answerIndex != null) {
      return;
    }
    cancelTimer();
    setState(() {
      _answerIndex = value;
    });
    await Future.delayed(const Duration(milliseconds: 250), () {});
    await _gameService.answerQuestion(
        _answerIndex, (_countDownDuration - _timeRemaining));
    setState(() {
      gamePhase = GamePhase.result;
      _score = _gameService.score;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Puntaje: $_score',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            Text(
              'Tiempo: $_timeRemaining',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            children: <Widget>[
              Text(
                'Pregunta ${_questionIndex + 1}',
                textAlign: TextAlign.center,
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
                      padding: EdgeInsets.all(8),
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
                      // height: 250,
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
              activeColor: Theme.of(context).colorScheme.primary,
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
    return Container(
      height: 200,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
                _answerIndex == _question.answerIndex ? 'Correcto' : 'Mal'),
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
      ),
    );
  }

  Widget _buildAction() {
    return ((_questionIndex + 1) == _gameService.questionLength
        ? RaisedButton(
            child: Text('Puntaje'),
            onPressed: _showNicknameDialog,
          )
        : RaisedButton(
            child: Text('Siguiente'),
            onPressed: getQuestion,
          ));
  }
}
