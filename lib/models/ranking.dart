import 'package:cloud_firestore/cloud_firestore.dart';

class Ranking {
  String id;
  String nickname;
  int score;

  Ranking({this.id, this.nickname, this.score});

  factory Ranking.fromGame(String id, String nickname, int score) {
    return Ranking(
      id: id,
      nickname: nickname,
      score: score,
    );
  }

  factory Ranking.fromFirestore(DocumentSnapshot document) {
    String id = document.documentID;
    Map data = document.data;
    return Ranking(
      id: id,
      nickname: data['nickname'],
      score: data['score'],
    );
  }
}
