import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/sizes.dart';

class InfoRow extends StatelessWidget {
  final IconData?icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 2.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 30.w,
            child: Row(
              children: [
                Icon(icon, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppSizes.body,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 17.w,),


          // Value column (left-aligned, starts right after label column)
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style:  TextStyle(
                fontSize: AppSizes.body,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}