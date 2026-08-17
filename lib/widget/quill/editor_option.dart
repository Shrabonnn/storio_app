import 'package:flutter/material.dart';

Widget editorOption(String text) {
  return Container(
    margin: EdgeInsets.only(right: 5),
    padding: EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 5,
    ),
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.grey.shade400,
      ),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey.shade700,
      ),
    ),
  );
}

