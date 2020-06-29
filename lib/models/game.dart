import 'package:healthytrivia/models/question.dart';

class Game {
  String id;
  String nickname;
  String userId;
  int difficulty;
  int score;
  DateTime initDate;
  DateTime endDate;
  List<Question> questions;

  Game({
    this.id,
    this.userId,
    this.difficulty,
    this.score,
    this.initDate,
    this.endDate,
    this.questions,
  });

  factory Game.withDifficulty(
    String id,
    String userId,
    int difficulty,
    List<Question> questions,
  ) {
    return Game(
      id: id,
      userId: userId,
      difficulty: difficulty,
      score: 0,
      initDate: DateTime.now(),
      endDate: DateTime.now(),
      questions: questions,
    );
  }

  Map<String, dynamic> toFirestore() => <String, dynamic>{
        'userId': userId,
        'nickname': nickname,
        'difficulty': difficulty,
        'score': score,
        'initDate': initDate,
        'endDate': endDate
      };
}
