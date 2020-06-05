class Answer {
  String questionId;
  String gameId;
  String userId;
  int answerIndex;
  int seconds;

  Answer({
    this.questionId,
    this.gameId,
    this.userId,
    this.answerIndex,
    this.seconds,
  });

  factory Answer.fromGame(
    String questionId,
    String gameId,
    String userId,
    int answerIndex,
    int seconds,
  ) {
    return Answer(
      questionId: questionId,
      gameId: gameId,
      userId: userId,
      answerIndex: answerIndex,
      seconds: seconds,
    );
  }

  Map<String, dynamic> toFirestore() => <String, dynamic>{
        'questionId': questionId,
        'gameId': gameId,
        'userId': userId,
        'answerIndex': answerIndex,
        'seconds': seconds,
      };
}
