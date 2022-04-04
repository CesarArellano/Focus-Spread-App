
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:focus_spread/theme/app_theme.dart';

class Helpers {

  static void showCustomDialog({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15) ),
        title: Text(title),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
        actions: [
          MaterialButton(
            child: const Text('Ok', style: TextStyle(color: AppTheme.primaryColor)),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ) 
    );
  }

  static void errorSnackBar({
    required BuildContext context,
    required String text,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.red,
      )
    );
  }

  static InputDecoration inputDecoration({
    required String hintText
  }) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      label: Text(hintText),
    );
  }
}

double log10(num x) => log(x) / ln10;