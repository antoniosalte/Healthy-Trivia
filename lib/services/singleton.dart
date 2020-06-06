import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthytrivia/models/answer.dart';
import 'package:healthytrivia/models/game.dart';
import 'package:healthytrivia/models/question.dart';
import 'package:healthytrivia/models/user.dart';
import 'package:healthytrivia/services/database_service.dart';

// Singleton
class Singleton {
  User _user;
  Game _game;
  int _questionIndex;

  Singleton._privateConstructor();

  static final Singleton _instance = Singleton._privateConstructor();

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DatabaseService _databaseService = DatabaseService();

  factory Singleton() {
    return _instance;
  }

  int get questionLength {
    return _game.questions.length;
  }

  int get score {
    return _game.score;
  }

  void _updateScore(int answerIndex, int seconds) {
    int correct =
        _game.questions[_questionIndex].answerIndex == answerIndex ? 1 : 0;
    int currentScore = correct * ((_game.difficulty * 100) - (seconds * 5));
    _game.score += currentScore;
  }

  Future<void> getUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    _user = User.fromFirebaseUser(user);
  }

  Future<void> createUser() async {
    await getUser();
    _databaseService.createUser(_user);
  }

  Future<void> createGame(int difficulty) async {
    if (_user == null) {
      await getUser();
    }

    _questionIndex = -1;
    _game = await _databaseService.createGame(_user.id, difficulty);
  }

  Future<void> endGame() async {
    DateTime endDate = DateTime.now();
    print(endDate);
    _game.endDate = endDate;
    print(_game.endDate);
    await _databaseService.endGame(_game);
  }

  Question getQuestion() {
    _questionIndex += 1;
    return _game.questions[_questionIndex];
  }

  Future<void> answerQuestion(int answerIndex, int seconds) async {
    Answer answer = Answer.fromGame(
      _game.questions[_questionIndex].id,
      _game.id,
      _user.id,
      answerIndex,
      seconds,
    );
    _updateScore(answerIndex, seconds);
    await _databaseService.answerQuestion(answer);
    if ((_questionIndex + 1) == questionLength) {
      await endGame();
    }
  }
}
