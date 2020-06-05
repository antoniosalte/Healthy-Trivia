import 'dart:async';
import 'package:flutter/material.dart';
import 'package:healthytrivia/models/question.dart';
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

  @override
  void initState() {
    getQuestion();
    super.initState();
  }

  void getQuestion() {
    setState(() {
      gamePhase = GamePhase.question;
      _questionIndex += 1;
      _answerIndex = null;
      _question = _singleton.getQuestion();
    });
  }

  Future<void> answerQuestion(int value) async {
    setState(() {
      _answerIndex = value;
      gamePhase = GamePhase.result;
    });
    _singleton.answerQuestion(_answerIndex, 0);
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
          child: Text('Next'),
          onPressed: getQuestion,
        ),
      ],
    );
  }
}
