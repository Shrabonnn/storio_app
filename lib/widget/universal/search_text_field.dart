import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key, required this.hinText, this.width, this.height, required this.controller});

  final String hinText;
  final double ? width;
  final double ? height;
  final TextEditingController  controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:height ?? 4.5.h,
      width: width ?? 60.w,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hinText,
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,

        ),
      ),
    );
  }
}
