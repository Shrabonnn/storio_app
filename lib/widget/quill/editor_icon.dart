import 'package:flutter/material.dart';

Widget editorIcon(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 5,
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
      ),
    ),
  );
}