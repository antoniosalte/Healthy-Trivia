import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Brightness;

class ThemeProvider with ChangeNotifier {
  bool isLightTheme;

  ThemeProvider({this.isLightTheme});

  ThemeData get getThemeData => isLightTheme ? lightTheme : darkTheme;

  set setThemeData(bool value) {
    isLightTheme = value;
    notifyListeners();
  }

  final lightTheme = ThemeData();
  final darkTheme = ThemeData();
}
