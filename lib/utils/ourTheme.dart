import 'package:flutter/material.dart';


class OurTheme {
  
  Color _backGround = Color.fromARGB(255, 251, 247, 248);
  Color _litters = Color.fromARGB(255, 66, 66, 66);
  Color _backButtons = Color.fromARGB(255, 202, 17, 0);
  // Color _lightGrey = Color.fromARGB(255, 164, 164, 164);
  // Color _darkerGrey = Color.fromARGB(255, 119, 124, 135);

  ThemeData buildTheme() {
    return ThemeData(
      canvasColor: _backGround,
      primaryColor: _backGround,
      accentColor: _litters,
      secondaryHeaderColor: _backButtons,
      hintColor: _litters,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: _litters,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: _backGround,
          ),
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: _backButtons,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        minWidth: 150,
        height: 40.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}