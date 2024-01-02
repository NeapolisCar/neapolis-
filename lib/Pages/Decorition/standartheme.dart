// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
class themes_App{
  static final darkTheme =ThemeData(
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        alignment: Alignment.center,
        //padding: MaterialStatePropertyAll(EdgeInsets.all(16)),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(10),top: Radius.circular(10)))),
      ),
    ),
      appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
          titleTextStyle:TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.15,
              color: alice_blue,
              fontFamily:"Rubik"
          ),
          iconTheme: IconThemeData(
              color: alice_blue,
              size: 24
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            statusBarColor:black,
            systemNavigationBarColor: indigo_blue,
            systemNavigationBarDividerColor: indigo_blue,
          )
      ),

      textTheme: const TextTheme(
        headline1: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.25,
            color: alice_blue,
            fontFamily:"Rubik"
        ),
        headline2: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.25,
            color: alice_blue,
            fontFamily:"Rubik"
        ),
        headline3: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            color: alice_blue,
            fontFamily:"Rubik"
        ),
        headline4: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
            color: alice_blue,
            fontFamily:"Roboto"
        ),
        headline5: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
            color: alice_blue,
            fontFamily:"Rubik"
        ),
        // headline6: TextStyle(
        //     fontSize: 20,
        //     fontWeight: FontWeight.bold,
        //     letterSpacing: 0.15,
        //     color: Colors.grey,
        //     fontFamily:"Rubik"
        // ),
        subtitle1: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: black,
            fontFamily:"Rubik"
        ),
        subtitle2: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: black,
            fontFamily:"Rubik"
        ),
        bodyText1: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.25,
            color:black,
            fontFamily:"Rubik"
        ),
        bodyText2: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.25,
            color:black,
            fontFamily:"Rubik"
        ),
        button:  TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color:alice_blue,
            fontFamily:"Rubik"
        ),
        caption: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
            color: Colors.grey,
            fontFamily:"Roboto"
        ),
      )

  );
}