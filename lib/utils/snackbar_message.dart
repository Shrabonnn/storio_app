import 'package:flutter/material.dart';

class SnackBarMessage {
  static void showSnackBar(
      BuildContext context,
      String message, {
        Color backgroundColor = Colors.black,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}