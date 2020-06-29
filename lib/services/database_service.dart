import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthytrivia/models/answer.dart';
import 'package:healthytrivia/models/game.dart';
import 'package:healthytrivia/models/question.dart';
import 'package:healthytrivia/models/ranking.dart';
import 'package:healthytrivia/models/user.dart';

/// Servicio que se encarga de registrar y pedir información a la Base de Datos (Cloud Firestore).
class DatabaseService {
  final Firestore _firestore = Firestore.instance;

  /// Crear un usario en Cloud Firestore.
  Future<void> createUser(User user) async {
    await _firestore
        .collection('users')
        .document(user.id)
        .setData(user.toFirestore());
  }

  /// Query para obtener las preguntas por el nivel de dificultad.
  Future<List<Question>> getQuestions(int difficulty) async {
    QuerySnapshot query = await _firestore
        .collection('questions')
        .where('difficulty', isEqualTo: difficulty)
        .getDocuments();

    List<Question> questions = List<Question>();

    for (DocumentSnapshot document in query.documents) {
      Question question = Question.fromFirestore(document);
      questions.add(question);
    }

    return questions;
  }

  /// Crear un juego con el id del usuario y el nivel de dificultad.
  Future<Game> createGame(String userId, int difficulty) async {
    DocumentReference documentReference =
        _firestore.collection('games').document();

    List<Question> questions = await getQuestions(difficulty);

    Game game = Game.withDifficulty(
      documentReference.documentID,
      userId,
      difficulty,
      questions,
    );

    await documentReference.setData(game.toFirestore());

    return game;
  }

  /// Cuando se finaliza un juego se registra el puntaje, el nickname y la fecha de culminación de un juego.
  Future<void> endGame(Game game) async {
    await _firestore.collection('games').document(game.id).updateData({
      'nickname': game.nickname,
      'endDate': game.endDate,
      'score': game.score,
    });
  }

  /// Actualiza el puntaje un juego cuando se responde una pregunta.
  Future<void> updateGameScore(Game game) async {
    await _firestore
        .collection('games')
        .document(game.id)
        .updateData({'score': game.score});
  }

  /// Registra la respuesta de un usuario.
  Future<void> answerQuestion(Answer answer) async {
    await _firestore
        .collection('answers')
        .document()
        .setData(answer.toFirestore());
  }

  /// Query para obtener los puntajes de juego por el nivel de dificultad.
  /// Estan ordenados de manera descendente respecto al puntaje.
  /// Solo se toman en cuenta los puntajes mayores a 0.
  Future<List<Ranking>> getRanking(int difficulty) async {
    QuerySnapshot query = await _firestore
        .collection('games')
        .where('difficulty', isEqualTo: difficulty)
        .getDocuments();
    List<Ranking> ranking = List<Ranking>();

    for (DocumentSnapshot document in query.documents) {
      Ranking _ranking = Ranking.fromFirestore(document);
      if (_ranking.score > 0) {
        ranking.add(_ranking);
      }
    }

    ranking.sort((b, a) => a.score.compareTo(b.score));

    return ranking;
  }
}
