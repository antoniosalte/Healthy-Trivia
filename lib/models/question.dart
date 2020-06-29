import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  String id;
  String question;
  List<dynamic> options;
  int answerIndex;
  int difficulty;
  String information;

  Question({
    this.id,
    this.question,
    this.options,
    this.answerIndex,
    this.difficulty,
    this.information,
  });

  factory Question.fromFirestore(DocumentSnapshot document) {
    String documentID = document.documentID;
    Map data = document.data;
    return Question(
      id: documentID,
      question: data['question'],
      options: data['options'],
      answerIndex: data['answerIndex'],
      difficulty: data['difficulty'],
      information: data['information'],
    );
  }
}
