import 'package:flutter/material.dart';
class themes_App{
  static final darkTheme =ThemeData(
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        alignment: Alignment.center,
        //padding: MaterialStatePropertyAll(EdgeInsets.all(16)),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10),top: Radius.circular(10)))),
      ),
    ),
        textTheme: const TextTheme(
        headline1: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.25,
            fontFamily:"Rubik"
          ),
          headline6: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.15,
              fontFamily:"Rubik"
          ),
          caption: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              letterSpacing: 0.4,

              fontFamily:"Rubik"
          ),
        )
  );
}