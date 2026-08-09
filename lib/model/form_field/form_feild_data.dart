import 'package:flutter/material.dart';

class FormFieldData {
  final String title;
  final String hint;
  final TextEditingController controller;

  FormFieldData({
    required this.title,
    required this.hint,
    required this.controller,
  });
}