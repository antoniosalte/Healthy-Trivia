import 'package:firebase_auth/firebase_auth.dart';

class User {
  String id;
  String name;
  String email;

  User({
    this.id,
    this.name,
    this.email,
  });

  factory User.fromFirebaseUser(FirebaseUser user) {
    return User(
      id: user.uid,
      name: user.displayName,
      email: user.email,
    );
  }

  Map<String, dynamic> toFirestore() => <String, dynamic>{
        'name': name,
        'email': email,
      };
}
