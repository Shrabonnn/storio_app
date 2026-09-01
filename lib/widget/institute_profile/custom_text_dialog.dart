import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/theme/theme_ext.dart';
import '../textStyle/text_body_style.dart';
import '../textStyle/text_title_style.dart';

class CustomTextDialog extends StatelessWidget {
  final String title;
  final String hintText;
  final String description;
  final IconData icon;
  final TextEditingController controller;
  final VoidCallback onSave;

  const CustomTextDialog({
    super.key,
    required this.title,
    required this.controller,
    required this.onSave,
    this.icon = Icons.edit_outlined,
    this.hintText = "Write here...",
    this.description = "",
  });

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return AlertDialog(
      backgroundColor: color.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      titlePadding: EdgeInsets.all(4.w),
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),

      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.primary.withValues(alpha: .1),
            child: Icon(icon, color: color.primary),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: TextTitleWidget(
              title: title,
              color: color.primary,
            ),
          ),
        ],
      ),

      content: Container(
        width: 80.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (description.isNotEmpty)
              TextBodyStyleWidget(
                title: description,
                maxLines: 2,
              ),

            if (description.isNotEmpty)
              SizedBox(height: 2.h),


            TextField(
              controller: controller,
              maxLines: 9,
              maxLength: 5000,
              decoration: InputDecoration(
                hintText: hintText,
                filled: true,
                fillColor: Colors.grey.shade100,

              ),
            ),

            SizedBox(height: 2.h),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onSave();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color.primary,
                      foregroundColor: color.cardBackground,
                    ),
                    child: const Text("Save"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

          ],
        ),
      ),
    );
  }
}