import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:moedeiro/theme/appTheme.dart';
import 'package:moedeiro/util/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  ThemeData lightTheme = AppTheme.lightTheme;
  ThemeData darkTheme = AppTheme.darkTheme;
  ThemeMode themeMode = ThemeMode.system;
  String _activeTheme = 'system';
  bool _lockScreen = false;
  bool _discreetMode = false;
  bool _useBiometrics = false;
  String _pin = '0000';
  late SharedPreferences prefs;
  String _localeString = '';
  Locale? locale;
  bool _firstTime = true;

  Future<bool> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    _discreetMode = prefs.getBool('discreetMode') ?? false;
    _lockScreen = prefs.getBool('lockApp') ?? false;
    _useBiometrics = prefs.getBool('useBiometrics') ?? false;
    _pin = prefs.getString('PIN') ?? '0000';
    _firstTime = prefs.getBool('firstTime') ?? true;
    _localeString = prefs.getString('locale') ?? 'system';
    if (_localeString == 'system') {
      locale = null;
    } else {
      var activeLocale =
          languageOptions.firstWhere((element) => element.key == _localeString);
      locale = Locale.fromSubtags(languageCode: activeLocale.key);
    }
    _activeTheme = prefs.getString('theme') ?? 'system';
    setActiveTheme(_activeTheme);
    return Future.value(true);
  }

  bool get firstTime => _firstTime;
  set firstTime(bool value) {
    _firstTime = value;
    notifyListeners();
    prefs.setBool('firstTime', value);
  }

  String get pin => _pin;
  set pin(String value) {
    _pin = value;
    notifyListeners();
    prefs.setString('PIN', _pin);
  }

  void removePin() {
    prefs.remove('PIN');
    _pin = '';
  }

  String get localeString => _localeString;
  set localeString(String value) {
    _localeString = value;

    notifyListeners();
    prefs.setString('locale', _localeString);
  }

  bool get useBiometrics => _useBiometrics;
  set useBiometrics(bool value) {
    _useBiometrics = value;
    notifyListeners();
    prefs.setBool('useBiometrics', _useBiometrics);
  }

  bool get lockScreen => _lockScreen;
  set lockScreen(bool value) {
    _lockScreen = value;
    notifyListeners();
    prefs.setBool('lockApp', _lockScreen);
  }

  bool get discreetMode => _discreetMode;
  set discreetMode(bool value) {
    _discreetMode = value;
    notifyListeners();
    prefs.setBool('discreetMode', _discreetMode);
  }

  String get activeTheme => _activeTheme;
  set activeTheme(String value) {
    setActiveTheme(value);
  }

  setSelectedThemeMode(ThemeMode _themeMode) {
    themeMode = _themeMode;
    prefs.setString('theme', _activeTheme.toString());
    notifyListeners();
  }

  void setActiveTheme(String value) {
    _activeTheme = value;
    switch (value) {
      case 'system':
        var brightness = SchedulerBinding.instance!.window.platformBrightness;
        if (Brightness.dark == brightness)
          themeMode = ThemeMode.dark;
        else
          themeMode = ThemeMode.light;
        break;

      case 'dark':
        themeMode = ThemeMode.dark;
        break;

      default:
        themeMode = ThemeMode.light;
        break;
    }
    notifyListeners();
    prefs.setString('theme', _activeTheme);
  }
}
