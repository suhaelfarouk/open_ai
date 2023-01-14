import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  Color colorBase = Colors.black;
  Color colorAccent = Colors.white;
  bool isLightModeOn = false;

  void isLightMode() {
    isLightModeOn = true;
    colorBase = Colors.white;
    colorAccent = Colors.black;
    notifyListeners();
  }

  void isDarkMode() {
    isLightModeOn = false;
    colorBase = Colors.black;
    colorAccent = Colors.white;
    notifyListeners();
  }
}
