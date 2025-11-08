import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData bluetheme = ThemeData(
  brightness: Brightness.light,
  textTheme: GoogleFonts.poppinsTextTheme(),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Colors.blue.shade100,
    onPrimary: Colors.blue.shade900,
    secondary: Colors.white,
    onSecondary: Colors.grey,
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
);
ThemeData pinkTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: GoogleFonts.poppinsTextTheme(),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Colors.pink.shade100,
    onPrimary: Colors.pink.shade400,
    secondary: Colors.white,
    onSecondary: Colors.grey,
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
);
ThemeData greenTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: GoogleFonts.poppinsTextTheme(),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Colors.green.shade100,
    onPrimary: Colors.green.shade800,
    secondary: Colors.white,
    onSecondary: Colors.grey,
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
);
ThemeData normalTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: GoogleFonts.poppinsTextTheme(),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Colors.grey.shade200,
    onPrimary: Colors.black,
    secondary: Colors.white,
    onSecondary: Colors.grey,
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
);
