import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthytrivia/services/singleton.dart';

class AuthProvider with ChangeNotifier {
  FirebaseUser user;
  StreamSubscription userSubscription;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Singleton _singleton = Singleton();

  AuthProvider() {
    userSubscription = _firebaseAuth.onAuthStateChanged.listen((newUser) {
      print('[AuthProvider][FirebaseAuth] onAuthStateChanged $newUser');
      user = newUser;
      notifyListeners();
    }, onError: (error) {
      print('[AuthProvider][FirebaseAuth] onAuthStateChanged $error');
    });
  }

  @override
  void dispose() {
    if (userSubscription != null) {
      userSubscription.cancel();
      userSubscription = null;
    }
    super.dispose();
  }

  bool get isAnonymous {
    assert(user != null);
    bool isAnonymusUser = true;
    for (UserInfo info in user.providerData) {
      if (info.providerId == "facebook.com" ||
          info.providerId == "google.com" ||
          info.providerId == "password") {
        isAnonymusUser = false;
      }
    }
    return isAnonymusUser;
  }

  bool get isAuthenticated {
    return user != null;
  }

  Future<void> signInAnonymously() async {
    await _firebaseAuth.signInAnonymously();
    _singleton.createUser();
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
