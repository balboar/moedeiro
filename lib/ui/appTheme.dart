import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Light Theme
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(
      color: Colors.grey[100],
      brightness: Brightness.light,
    ),
    primaryTextTheme: TextTheme(
      title: TextStyle(color: Colors.blue),
    ),
    scaffoldBackgroundColor: Colors.grey[200],
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.white,
      shape: RoundedRectangleBorder(),
      textTheme: ButtonTextTheme.primary,
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(
      color: Colors.grey[850],
      brightness: Brightness.dark,
    ),
    primaryTextTheme: TextTheme(
      title: TextStyle(color: Colors.pink),
    ),
    scaffoldBackgroundColor: Colors.grey[900],
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.grey[850],
      shape: RoundedRectangleBorder(),
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
