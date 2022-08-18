import 'package:flutter/material.dart';

class ThemaProvedor extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toogleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.dark;
    notifyListeners();
  }
}

class MeuTema {
  static final darkMode = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(),
  );
  static final lightMode = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(),
  );

  //get isDarkMode => null;

  // bool isDartTheme = false;

  // static ThemeController instance = ThemeController();

  // changeTheme() {
  //   isDartTheme = !isDartTheme;
  //   notifyListeners();
  //   log("testando" + isDartTheme.toString());
  // }
}
