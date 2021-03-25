import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    accentColor: Colors.black, // Colors.blue[300],
    buttonBarTheme: ButtonBarThemeData(
        alignment: MainAxisAlignment.spaceAround, buttonHeight: 40.0),
    // textSelectionTheme: TextSelectionThemeData(selectionColor: Colors.black),
    cardColor: Colors.white,
    textTheme: TextTheme(
        button: TextStyle(color: Colors.white),
        bodyText1: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
    canvasColor: Colors.grey[50],
    brightness: Brightness.light,
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
    ),
    iconTheme: IconThemeData(color: Colors.black),
    appBarTheme: AppBarTheme(
      color: Colors.grey[50],
      actionsIconTheme: IconThemeData(color: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0.0,
      brightness: Brightness.light,
      centerTitle: true,
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    primaryColor: Color(0xFF232d3a),
    primaryColorDark: Color(0xFF1c242e),
    scaffoldBackgroundColor: Color(0xFF1f2732),

    //primarySwatch: Colors.blue,
    accentColor: Color(0xFFFAEBD7), //Colors.blue[300],
    cardColor: Color(
        0xFF334051), //293342), //Colors.grey[900].withOpacity(0.8), //Color(0xFF151515),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Color(0xFF1f2732), // Color(0xFF293342),
    ),

    buttonBarTheme: ButtonBarThemeData(
        alignment: MainAxisAlignment.spaceAround, buttonHeight: 40.0),
    textTheme: TextTheme(
        button: TextStyle(color: Colors.black),
        bodyText1: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
    // canvasColor: Color(0xFF020203),
    brightness: Brightness.dark,
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFF293342),
    ),
    toggleableActiveColor: Color(0xFFFAEBD7), // Colors.blue[400],
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
    ),
    appBarTheme: AppBarTheme(
      color: Color(0xFF293342), // Color(0xFF151515),
      elevation: 0.0, centerTitle: true,
    ),
  );
}
