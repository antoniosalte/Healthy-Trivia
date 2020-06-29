import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthytrivia/models/answer.dart';
import 'package:healthytrivia/models/game.dart';
import 'package:healthytrivia/models/question.dart';
import 'package:healthytrivia/models/ranking.dart';
import 'package:healthytrivia/models/user.dart';
import 'package:healthytrivia/services/database_service.dart';

/// Servicio que se encarga de manejar las partidas de juego de la apliación.
/// Usa el patrón Singleton para que se pueda acceder desde cualquier pantalla de la aplicación.
class GameService {
  User _user;
  Game _game;
  int _questionIndex;

  GameService._privateConstructor();

  static final GameService _instance = GameService._privateConstructor();

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DatabaseService _databaseService = DatabaseService();

  /// Retorna la instancia actual del servicio.
  factory GameService() {
    return _instance;
  }

  /// Retorna la cantidad de preguntas.
  int get questionLength {
    return _game.questions.length;
  }

  /// Retorna el puntaje actual.
  int get score {
    return _game.score;
  }

  /// Crea el puntaje del juego actual para el formato de los puntajes de juego.
  Ranking createRanking(String nickname) {
    Ranking ranking = Ranking.fromGame(_game.id, nickname, _game.score);
    return ranking;
  }

  /// Actualiza el puntaje del juego con el puntaje de una pregunta.
  /// Si se respondió de manera errónea una pregunta, el puntaje siempre será 0.
  /// Si se respondió de manera correcta una pregunta, el puntaje de esta se determina
  /// por un puntaje base por grado de dificultad menos el tiempo que tardó en responder la pregunta.
  void _updateScore(int answerIndex, int seconds) {
    int correct =
        _game.questions[_questionIndex].answerIndex == answerIndex ? 1 : 0;
    int currentScore =
        correct * (((_game.difficulty + 1) * 100) - (seconds * 5));

    _game.score += currentScore;
  }

  /// Obtiene el usuario actual.
  Future<void> getUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    _user = User.fromFirebaseUser(user);
  }

  /// Crea un usuario para el servicio.
  Future<void> createUser() async {
    await getUser();
    _databaseService.createUser(_user);
  }

  /// Crea un juego con el nivel de dificultad.
  /// Si el servicio no tiene un usuario lo obtiene primero.
  Future<void> createGame(int difficulty) async {
    if (_user == null) {
      await getUser();
    }

    _questionIndex = -1;
    _game = await _databaseService.createGame(_user.id, difficulty);
  }

  /// Finaliza un juego obteniendo el nickname del usuario y registrando la fecha de culminación.
  Future<void> endGame(String nickname) async {
    _game.endDate = DateTime.now();
    _game.nickname = nickname;
    await _databaseService.endGame(_game);
  }

  /// Retorna una nueva pregunta.
  Question getQuestion() {
    _questionIndex += 1;
    return _game.questions[_questionIndex];
  }

  /// Registra la respuesta del usuario y el tiempo que se demoró en responderla.
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
  }

  /// Retornar los puntajes de juego.
  Future<List<Ranking>> getRanking() async {
    List<Ranking> ranking = await _databaseService.getRanking(_game.difficulty);
    return ranking;
  }
}
