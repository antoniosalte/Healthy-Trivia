import 'package:cloud_firestore/cloud_firestore.dart';

class Ranking {
  String username;
  int score;

  Ranking({this.username, this.score});

  factory Ranking.fromFirestore(DocumentSnapshot document) {
    Map data = document.data;
    return Ranking(
      username: data['username'],
      score: data['score'],
    );
  }
}
