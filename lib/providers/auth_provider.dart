import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthytrivia/services/game_service.dart';

/// Proveedor que se encargá de manejar la autenticación de la aplicación.
class AuthProvider with ChangeNotifier {
  FirebaseUser user;
  StreamSubscription userSubscription;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  GameService _gameService = GameService();

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

  /// Verificar si un usuario esta autenticado de manera anónima.
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

  /// Verficiar si existe un usuario autenticado.
  bool get isAuthenticated {
    return user != null;
  }

  /// Ingresa a la aplicación de manera anonima;
  Future<void> signInAnonymously() async {
    await _firebaseAuth.signInAnonymously();
    _gameService.createUser();
  }

  /// Cerrar sesión en la aplicación.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
