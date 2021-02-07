import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:moedeiro/theme/appTheme.dart';

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

  ThemeMode getThemeMode() {
    switch (themeMode) {
      case ThemeMode.system:
        var brightness = SchedulerBinding.instance.window.platformBrightness;
        if (Brightness.dark == brightness)
          return ThemeMode.dark;
        else
          return ThemeMode.light;
        break;
      case ThemeMode.dark:
        return ThemeMode.dark;
        break;
      default:
        return ThemeMode.light;
    }
  }
}
