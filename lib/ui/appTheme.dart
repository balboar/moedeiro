import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.grey,
    accentColor: Colors.blue[300],
    textSelectionColor: Colors.black,
    cardColor: Colors.white,
    textTheme: TextTheme(
        bodyText1: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
    canvasColor: Colors.grey[50],
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      color: Colors.grey[50],
      elevation: 0.0,
      brightness: Brightness.light,
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    primaryColor: Color(0xFF232d3a),
    primaryColorDark: Color(0xFF1c242e),
    scaffoldBackgroundColor: Color(0xFF1f2732),

    //primarySwatch: Colors.blue,
    accentColor: Colors.blue[300],
    cardColor: Color(
        0xFF334051), //293342), //Colors.grey[900].withOpacity(0.8), //Color(0xFF151515),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Color(0xFF293342),
    ),
    textTheme: TextTheme(
        bodyText1: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
    // canvasColor: Color(0xFF020203),
    brightness: Brightness.dark,
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFF293342),
    ),
    toggleableActiveColor: Colors.blue[400],
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
    ),
    appBarTheme: AppBarTheme(
      color: Color(0xFF293342), // Color(0xFF151515),
      elevation: 0.0,
    ),
  );
}
