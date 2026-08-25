import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/sizes.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key, required this.hinText, this.width, this.height, required this.controller, required this.onChanged});

  final String hinText;
  final double ? width;
  final double ? height;
  final TextEditingController  controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:height ?? 4.5.h,
      width: width ?? 60.w,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
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
