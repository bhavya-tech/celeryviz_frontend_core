import 'package:flutter/material.dart';

final ThemeData defaultTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blue,
  canvasColor: const Color(0xFF121212),
  useMaterial3: true,
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStatePropertyAll<Color>(Colors.black),
    ),
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    showCloseIcon: true,
    behavior: SnackBarBehavior.floating,
    width: 300,
  ),
);
