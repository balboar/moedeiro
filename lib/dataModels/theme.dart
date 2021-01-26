import 'package:flutter/material.dart';
import 'package:moedeiro/ui/appTheme.dart';

class ThemeModel extends ChangeNotifier {
  ThemeData lightTheme = AppTheme.lightTheme;
  ThemeData darkTheme = AppTheme.darkTheme;
  ThemeMode themeMode = ThemeMode.system;

  setDark() {
    themeMode = ThemeMode.dark;
    return notifyListeners();
  }

  setLight() {
    themeMode = ThemeMode.light;
    return notifyListeners();
  }

  setSystemDefault() {
    themeMode = ThemeMode.system;
    return notifyListeners();
  }
}
