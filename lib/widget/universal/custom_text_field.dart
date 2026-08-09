import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart' ;

import '../../utils/sizes.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int?minLines;
  final int?maxLines;

  const CustomTextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText, this.minLines, this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 2,
            spreadRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.cardPadding),
        child: TextFormField(

          minLines: minLines ?? 1,
          maxLines: maxLines ?? 2,
          controller: controller,
          style: TextStyle(
            fontSize: AppSizes.cardSubTitle,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            isCollapsed: true,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}