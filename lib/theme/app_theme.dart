import 'package:flutter/material.dart';

class AppTheme {

  static const primaryColor = Colors.green;

  static final lightTheme = ThemeData.light().copyWith(
    primaryColor: primaryColor,
    colorScheme: ThemeData().colorScheme.copyWith( // Change color icons TextFormField
      primary: primaryColor,
    ),
  );
}