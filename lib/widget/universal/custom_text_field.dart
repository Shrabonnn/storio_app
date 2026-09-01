import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart' ;

import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int?minLines;
  final int?maxLines;
  final bool isDatePicker;
  final VoidCallback?onChange;
  final bool enable;

  const CustomTextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText, this.minLines, this.maxLines,
    this.isDatePicker = false, this.onChange,  this.enable=true,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      controller.text =
      "${pickedDate.month.toString().padLeft(2, '0')}/"
          "${pickedDate.day.toString().padLeft(2, '0')}/"
          "${pickedDate.year.toString().substring(2)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Container(
      width: 100.w,
      decoration: BoxDecoration(
        color: color.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 2,
            spreadRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.cardPadding),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            TextFormField(
              enabled: enable,
              controller: controller,
              readOnly: isDatePicker,

              minLines: minLines ?? 1,
              maxLines: maxLines ?? 2,

              onTap: isDatePicker
                  ? () => _selectDate(context)
                  : null,

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


                suffix: null,
              ),
            ),


            if (isDatePicker)
              GestureDetector(
                onTap: () => _selectDate(context),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}