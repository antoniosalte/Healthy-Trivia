import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthytrivia/models/answer.dart';
import 'package:healthytrivia/models/game.dart';
import 'package:healthytrivia/models/question.dart';
import 'package:healthytrivia/models/ranking.dart';
import 'package:healthytrivia/models/user.dart';

class DatabaseService {
  final Firestore _firestore = Firestore.instance;

  Future<void> createUser(User user) async {
    await _firestore
        .collection('users')
        .document(user.id)
        .setData(user.toFirestore());
  }

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

  Future<void> endGame(Game game) async {
    await _firestore.collection('games').document(game.id).updateData({
      'nickname': game.nickname,
      'endDate': game.endDate,
      'score': game.score,
    });
  }

  Future<void> updateGameScore(Game game) async {
    await _firestore
        .collection('games')
        .document(game.id)
        .updateData({'score': game.score});
  }

  Future<void> answerQuestion(Answer answer) async {
    await _firestore
        .collection('answers')
        .document()
        .setData(answer.toFirestore());
  }

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
