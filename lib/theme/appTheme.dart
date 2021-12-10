import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    // primarySwatch: Colors.blueGrey,
    colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.teal,
        cardColor: Colors.white,
        brightness: Brightness.light,
        accentColor: Color(0xFF2596be)),
    buttonBarTheme: ButtonBarThemeData(
        alignment: MainAxisAlignment.spaceAround, buttonHeight: 40.0),
    textSelectionTheme: TextSelectionThemeData(selectionColor: Colors.black),
    iconTheme: IconThemeData(color: Colors.black),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),
    textTheme: TextTheme(
      button: TextStyle(color: Colors.white),
      bodyText1: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(color: Colors.black),
    ),

    canvasColor: Colors.grey[50],
    primaryTextTheme: TextTheme(
      headline6: TextStyle(color: Colors.black),
      bodyText1: TextStyle(color: Colors.black),
    ),

    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
          fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: Colors.black),
      color: Colors.grey[50],
      actionsIconTheme: IconThemeData(color: Colors.black),
      elevation: 0.0,
      centerTitle: true,
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    primaryColor: Color(0xFF232d3a),
    primaryColorDark: Color(0xFF1c242e),
    scaffoldBackgroundColor: Color(0xFF1f2732),
    colorScheme: ColorScheme.fromSwatch(
        cardColor: Color(0xFF334051),
        brightness: Brightness.dark,
        accentColor: Color(0xFFFAEBD7)),
    //primarySwatch: Colors.blue,
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Color(0xFF1f2732), // Color(0xFF293342),
    ),

    buttonBarTheme: ButtonBarThemeData(
        alignment: MainAxisAlignment.spaceAround, buttonHeight: 40.0),
    textTheme: TextTheme(
        button: TextStyle(color: Colors.black),
        bodyText1: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
    // canvasColor: Color(0xFF020203),

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
