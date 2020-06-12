import 'package:cloud_firestore/cloud_firestore.dart';

class Ranking {
  String nickname;
  int score;

  Ranking({this.nickname, this.score});

  factory Ranking.fromGame(String nickname, int score) {
    return Ranking(
      nickname: nickname,
      score: score,
    );
  }

  factory Ranking.fromFirestore(DocumentSnapshot document) {
    Map data = document.data;
    return Ranking(
      nickname: data['nickname'],
      score: data['score'],
    );
  }
}
