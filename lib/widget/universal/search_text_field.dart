import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/utils/app_sizes.dart';

import '../../utils/theme/theme_ext.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key, required this.hinText, this.width, this.height, required this.controller, required this.onChanged});

  final String hinText;
  final double ? width;
  final double ? height;
  final TextEditingController  controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return SizedBox(
      height:height ?? 4.5.h,
      width: width ?? 60.w,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hinText,
          hintStyle: TextStyle(
            color: color.textSecondary,
            fontSize: 14,
          ),
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: color.cardBackground,

        ),
      ),
    );
  }
}
