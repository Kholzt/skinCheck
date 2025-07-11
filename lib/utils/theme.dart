import 'package:flutter/material.dart';

// const primaryColor = Color(0xFF36A693);
// const secondaryColor = Color(0xFF69D7C4);
const secondaryColor = Color(0xFF69D7C4); // Sekarang jadi lebih terang
// const primaryColor = Color(0xFF06A98D); // Sekarang jadi lebih gelap
const primaryColor = Color(0xFF06A98D); // Sekarang jadi lebih gelap

final ThemeData customTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.light,
    secondary: secondaryColor,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300), // abu-abu muda
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: primaryColor, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    labelStyle: TextStyle(color: primaryColor),
    hintStyle: TextStyle(fontSize: 14),
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 16),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: primaryColor,
    ),
  ),
);
