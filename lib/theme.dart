import 'package:flutter/material.dart';

final theme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.teal[300],
  accentColor: Colors.lightGreen[700],
  fontFamily: 'Raleway',
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(primary: Colors.cyan[600]),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.lightGreen[700],
    selectedItemColor: Colors.amber[600],
    unselectedItemColor: Colors.white,
  ),
);
