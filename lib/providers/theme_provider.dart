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
}

final lightTheme = ThemeData(
  colorScheme: colorSchemeLight,
  primaryColor: colorSchemeLight.primary,
  errorColor: colorSchemeLight.error,
  backgroundColor: colorSchemeLight.background,
  accentColor: colorSchemeLight.primary,
  brightness: colorSchemeLight.brightness,
  buttonColor: colorSchemeLight.primary,
  appBarTheme: appBarTheme,
  inputDecorationTheme: inputDecorationThemeLight,
);

final darkTheme = ThemeData(
  colorScheme: colorSchemeDark,
  primaryColor: colorSchemeDark.primary,
  errorColor: colorSchemeDark.error,
  backgroundColor: colorSchemeDark.background,
  accentColor: colorSchemeDark.secondary,
  brightness: colorSchemeDark.brightness,
  buttonColor: colorSchemeLight.primary,
  appBarTheme: appBarTheme,
  inputDecorationTheme: inputDecorationThemeDark,
);

final appBarTheme = AppBarTheme(
  color: Colors.transparent,
  elevation: 0.0,
);

final inputDecorationThemeLight = InputDecorationTheme(
  hoverColor: colorSchemeLight.primary,
  border: OutlineInputBorder(
    borderSide: BorderSide(color: colorSchemeLight.primary),
  ),
);

final inputDecorationThemeDark = InputDecorationTheme(
  hoverColor: colorSchemeDark.primary,
  border: OutlineInputBorder(
    borderSide: BorderSide(color: colorSchemeDark.primary),
  ),
);

final colorSchemeLight = ColorScheme(
  primary: const Color(0xFFFF8642),
  primaryVariant: const Color(0xFFFF8642),
  secondary: const Color(0xFF41BAFF),
  secondaryVariant: const Color(0xFF41BAFF),
  surface: Colors.white,
  background: Colors.white,
  error: Colors.red,
  onPrimary: const Color(0xFF41BAFF),
  onSecondary: const Color(0xFF41BAFF),
  onSurface: Colors.black,
  onBackground: Colors.black,
  onError: Colors.black,
  brightness: Brightness.light,
);

final colorSchemeDark = ColorScheme(
  primary: const Color(0xFFFF8642),
  primaryVariant: const Color(0xFFFF8642),
  secondary: const Color(0xFF41BAFF),
  secondaryVariant: const Color(0xFF41BAFF),
  surface: Colors.grey[850],
  background: Colors.grey[850],
  error: Colors.red,
  onPrimary: const Color(0xFF41BAFF),
  onSecondary: const Color(0xFF41BAFF),
  onSurface: Colors.white,
  onBackground: Colors.white,
  onError: Colors.white,
  brightness: Brightness.dark,
);
