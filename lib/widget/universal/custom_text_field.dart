import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int? minLines;
  final int? maxLines;

  final bool isDatePicker;
  final bool isTimePicker;

  final VoidCallback? onChange;
  final bool enable;

  const CustomTextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.minLines,
    this.maxLines,
    this.isDatePicker = false,
    this.isTimePicker = false,
    this.onChange,
    this.enable = true,
  });

  // ============================================================
  // Date Picker
  // ============================================================

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      controller.text = DateFormat('dd MMM yyyy').format(pickedDate);
    }
  }

  // ============================================================
  // Time Picker
  // ============================================================

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      controller.text = pickedTime.format(context);
    }
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    final bool isPicker = isDatePicker || isTimePicker;

    return Container(
      width: 100.w,
      decoration: BoxDecoration(
        color: color.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: color.textSecondary.withOpacity(0.08),
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
              readOnly: isPicker,

              minLines: minLines ?? 1,
              maxLines: maxLines ?? 2,

              onTap: isDatePicker
                  ? () => _selectDate(context)
                  : isTimePicker
                  ? () => _selectTime(context)
                  : null,

              style: TextStyle(
                fontSize: AppSizes.cardSubTitle,
                fontWeight: FontWeight.w500,
              ),

              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: color.textSecondary,
                ),

                isCollapsed: true,

                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,

                contentPadding: EdgeInsets.zero,
              ),
            ),

            // Date Icon
            if (isDatePicker)
              GestureDetector(
                onTap: () => _selectDate(context),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  size: 20,
                ),
              ),

            // Time Icon
            if (isTimePicker)
              GestureDetector(
                onTap: () => _selectTime(context),
                child: const Icon(
                  Icons.access_time,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}